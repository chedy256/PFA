from fastapi import APIRouter, Depends, HTTPException
from deps import get_current_user

router = APIRouter(prefix="/documents", tags=["documents"])

@router.post("/{internship_id}")
def generate_document(
    internship_id: str,
    user = Depends(get_current_user)
):
    if user.role != "admin":
        raise HTTPException(status_code=403)

    # Here you would:
    # - Load data
    # - Render HTML
    # - Generate PDF with WeasyPrint
    # - Save file + DB entry

    return {"message": "Document generated"}
