from __future__ import annotations

from pathlib import Path

from flask import Flask, Response, request
from playwright.sync_api import Error as PlaywrightError
from playwright.sync_api import sync_playwright

app = Flask(__name__)


def _render_html_to_pdf_bytes(html_path: Path) -> bytes:
  if not html_path.exists():
    raise FileNotFoundError(f"Template not found: {html_path}")

  with sync_playwright() as p:
    browser = p.chromium.launch()
    page = browser.new_page()

    page.goto(html_path.as_uri(), wait_until="load")
    pdf_bytes = page.pdf(
      format="A4",
      print_background=True,
      prefer_css_page_size=True,
    )

    browser.close()
    return pdf_bytes

@app.route("/generate-fiche", methods=["GET"])
def generate_pdf():
  try:
    template = (request.args.get("template") or "ete").strip().lower()
    templates = {
      "ete": "fiche_information_ete.html",
      "pfe": "fiche_information_pfe.html",
    }
    if template not in templates:
      return {"error": "invalid template", "allowed": sorted(templates.keys())}, 400

    html_path = Path(__file__).with_name(templates[template]).resolve()
    pdf_bytes = _render_html_to_pdf_bytes(html_path)

    response = Response(pdf_bytes, content_type="application/pdf")
    response.headers["Content-Disposition"] = f"inline; filename={html_path.stem}.pdf"
    return response
  except Exception as e:
    if isinstance(e, PlaywrightError):
      return {
        "error": "pdf generation failed (playwright)",
        "hint": "Run: .\\.venv\\Scripts\\python.exe -m playwright install chromium",
      }, 500
    return {"error": "pdf generation failed"}, 500

if __name__ == "__main__":
  app.run(debug=True)