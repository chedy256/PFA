import uuid
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.models import Internship
from app.schemas import InternshipCreate, InternshipOut
from app.deps import get_db, get_current_user

router = APIRouter(prefix="/internships", tags=["internships"])


@router.post("/", response_model=InternshipOut)
def create_internship(
    data: InternshipCreate,
    user=Depends(get_current_user),
    db: Session = Depends(get_db),
):
    if user.role != "student":
        raise HTTPException(status_code=403)

    internship = Internship(
        id=str(uuid.uuid4()),
        student_id=user.id,
        title=data.title,
        description=data.description,
        type=data.type,
        company_name=data.company_name,
        company_address=data.company_address,
        company_sector=data.company_sector,
        company_phone=data.company_phone,
        supervisor_name=data.supervisor_name,
        supervisor_email=data.supervisor_email,
        supervisor_function=data.supervisor_function,
    )
    db.add(internship)
    db.commit()
    db.refresh(internship)
    return internship


@router.get("/", response_model=list[InternshipOut])
def list_internships(user=Depends(get_current_user), db: Session = Depends(get_db)):
    if user.role == "admin":
        return db.query(Internship).all()
    if user.role == "student":
        return db.query(Internship).filter_by(student_id=user.id).all()
    if user.role == "teacher":
        return db.query(Internship).filter_by(teacher_id=user.id).all()
    return []
