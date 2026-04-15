from typing import Any, Dict, Optional
from pathlib import Path
from fastapi import APIRouter, Depends, HTTPException, Response
from jinja2 import Environment, FileSystemLoader
from playwright.async_api import async_playwright
from pydantic import BaseModel
from app.deps import get_current_user, get_db

router = APIRouter(prefix="/documents", tags=["documents"])

# Jinja2 environment setup
TEMPLATE_DIR = Path(__file__).parent.parent.parent / "storage" / "templates"
jinja_env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))

class FicheData(BaseModel):
    template: str = "ete"
    data: Optional[Dict[str, Any]] = None

async def _render_html_to_pdf_bytes(html_content: str, base_url: str) -> bytes:
    async with async_playwright() as p:
        browser = await p.chromium.launch()
        page = await browser.new_page()
        await page.goto(f"file://{base_url}/")
        await page.set_content(html_content, wait_until="load")
        
        pdf_bytes = await page.pdf(
            format="A4",
            print_background=True,
            prefer_css_page_size=True,
        )

        await browser.close()
        return pdf_bytes

@router.post("/generate-fiche")
async def generate_pdf(request_data: FicheData):
    try:
        templates = {
            "ete": "fiche_information_ete.html",
            "pfe": "fiche_information_pfe.html",
        }
        
        template_name = request_data.template.strip().lower()
        if template_name not in templates:
            raise HTTPException(
                status_code=400, 
                detail={"error": "invalid template", "allowed": sorted(templates.keys())}
            )

        template_file = templates[template_name]
        template = jinja_env.get_template(template_file)
        
        render_data = request_data.data or {}
        html_content = template.render(**render_data)

        pdf_bytes = await _render_html_to_pdf_bytes(html_content, str(TEMPLATE_DIR))

        return Response(
            content=pdf_bytes, 
            media_type="application/pdf",
            headers={"Content-Disposition": f"inline; filename={template_name}.pdf"}
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@router.get("/{internship_id}/document.pdf")
async def generate_document(
    internship_id: str, 
    user=Depends(get_current_user),
    db=Depends(get_db)
):
    from sqlalchemy.orm import Session
    from app.models import Internship

    internship = db.query(Internship).filter(Internship.id == internship_id).first()
    if not internship:
        raise HTTPException(status_code=404, detail="Internship not found")
        
    student = internship.student

    # mapping fields to jinja format
    render_data = {
        "student_name": f"{student.first_name} {student.last_name}" if student else "",
        "cin": student.cin_number if student and student.cin_number else "",
        "filiere": student.department if student and student.department else "",
        "email": student.email if student else "",
        "phone": student.phone_number if student and student.phone_number else "",
        "company_name": internship.company_name or "",
        "company_address": internship.company_address or "",
        "company_sector": internship.company_sector or "",
        "company_phone": internship.company_phone or "",
        "supervisor_name": internship.supervisor_name or "",
        "supervisor_email": internship.supervisor_email or "",
        "supervisor_function": internship.supervisor_function or "",
        "title": internship.title or "",
        "start_day": internship.start_date.day if internship.start_date else "",
        "start_month": internship.start_date.month if internship.start_date else "",
        "start_year": internship.start_date.year if internship.start_date else "",
        "end_day": internship.end_date.day if internship.end_date else "",
        "end_month": internship.end_date.month if internship.end_date else "",
        "end_year": internship.end_date.year if internship.end_date else "",
    }

    template_name = "pfe" if internship.type == "pfe" else "ete"
    template_file = f"fiche_information_{template_name}.html"
    template = jinja_env.get_template(template_file)
    
    html_content = template.render(**render_data)
    pdf_bytes = await _render_html_to_pdf_bytes(html_content, str(TEMPLATE_DIR))

    return Response(
        content=pdf_bytes, 
        media_type="application/pdf",
        headers={"Content-Disposition": f"inline; filename=internship_{internship_id}_{template_name}.pdf"}
    )