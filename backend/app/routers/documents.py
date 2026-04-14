from typing import Any, Dict, Optional
from pathlib import Path
from fastapi import APIRouter, Depends, HTTPException, Response
from jinja2 import Environment, FileSystemLoader
from playwright.async_api import async_playwright
from pydantic import BaseModel
from app.deps import get_current_user

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

@router.post("/{internship_id}")
def generate_document(internship_id: str, user=Depends(get_current_user)):
    if user.role != "admin":
        raise HTTPException(status_code=403)
    return {"message": "Document generated"}