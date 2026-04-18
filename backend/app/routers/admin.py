from typing import Annotated
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_db, get_current_admin
from app.models import User, UserRole
from app.schemas import UserOut
from pydantic import BaseModel, EmailStr
import uuid

router = APIRouter(prefix="/admin", tags=["admin"])

class TeacherCreate(BaseModel):
    first_name: str
    last_name: str
    email: EmailStr

@router.post("/teachers", response_model=UserOut)
def create_teacher(
    data: TeacherCreate,
    admin: Annotated[User, Depends(get_current_admin)],
    db: Annotated[Session, Depends(get_db)]
):
    existing_user = db.query(User).filter(User.email == data.email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="User with this email already exists")

    # Generate a dummy UUID since Firebase user might not exist yet, 
    # or you can implement a logic to create them in Firebase Admin SDK.
    new_user_id = str(uuid.uuid4())
    new_user = User(
        id=new_user_id,
        firebase_uid=f"pending-{new_user_id}", # Placeholder until they log in
        first_name=data.first_name,
        last_name=data.last_name,
        email=data.email,
        role=UserRole.teacher
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user
