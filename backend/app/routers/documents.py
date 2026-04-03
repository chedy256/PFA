from fastapi import APIRouter, Depends, HTTPException
from app.deps import get_current_user

router = APIRouter(prefix="/documents", tags=["documents"])


@router.post("/{internship_id}")
def generate_document(internship_id: str, user=Depends(get_current_user)):
    if user.role != "admin":
        raise HTTPException(status_code=403)
    return {"message": "Document generated"}
