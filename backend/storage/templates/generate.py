from __future__ import annotations

from pathlib import Path
from typing import Any, Dict, Optional

from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import Response
from jinja2 import Environment, FileSystemLoader
from playwright.sync_api import Error as PlaywrightError
from playwright.sync_api import sync_playwright
from pydantic import BaseModel

app = FastAPI()

# Jinja2 environment setup
TEMPLATE_DIR = Path(__file__).parent.resolve()
jinja_env = Environment(loader=FileSystemLoader(TEMPLATE_DIR))

class FicheData(BaseModel):
    template: str = "ete"
    data: Optional[Dict[str, Any]] = None

def _render_html_to_pdf_bytes(html_content: str, base_url: str) -> bytes:
    with sync_playwright() as p:
        browser = p.chromium.launch()
        page = browser.new_page()

        # Set content directly from Jinja2 rendered HTML
        # Using a file:// URL as the base URL to allow loading local resources (e.g., images)
        page.goto(f"file://{base_url}/")
        page.set_content(html_content, wait_until="load")
        
        pdf_bytes = page.pdf(
            format="A4",
            print_background=True,
            prefer_css_page_size=True,
        )

        browser.close()
        return pdf_bytes

@app.post("/generate-fiche")
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
        
        # Render HTML with data
        render_data = request_data.data or {}
        
        # Add absolute path for images (Jinja2 will use it for src attributes if we use a helper)
        # However, it's easier to use base_url in HTML if we can.
        # For ISIM_LOGO_ar.png, we expect it to be in TEMPLATE_DIR.
        
        html_content = template.render(**render_data)

        pdf_bytes = _render_html_to_pdf_bytes(html_content, str(TEMPLATE_DIR))

        return Response(
            content=pdf_bytes, 
            media_type="application/pdf",
            headers={"Content-Disposition": f"inline; filename={template_name}.pdf"}
        )
    except Exception as e:
        if isinstance(e, PlaywrightError):
            raise HTTPException(
                status_code=500,
                detail={
                    "error": "pdf generation failed (playwright)",
                    "hint": "Run: playwright install chromium",
                }
            )
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/generate-fiche")
async def generate_pdf_get(
    template: str = Query("ete"),
    student_name: Optional[str] = Query(None, alias="student_full_name"),
    # Add other common fields as optional query params if needed
):
    # For GET, we just support a few fields or none for a blank form
    data = {"student_full_name": student_name} if student_name else {}
    return await generate_pdf(FicheData(template=template, data=data))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)