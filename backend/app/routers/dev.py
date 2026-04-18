from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.deps import get_db
from app.models import User, UserRole
import uuid

router = APIRouter(prefix="/dev", tags=["dev"])

@router.post("/seed-test-users")
def seed_test_users(db: Session = Depends(get_db)):
    test_users = [
        {"role": UserRole.student, "first_name": "Test", "last_name": "Student", "email": "student@test.com"},
        {"role": UserRole.teacher, "first_name": "Test", "last_name": "Teacher", "email": "teacher@test.com"},
        {"role": UserRole.admin, "first_name": "Test", "last_name": "Admin", "email": "admin@test.com"},
    ]
    
    created = {}
    for t_user in test_users:
        user = db.query(User).filter(User.email == t_user["email"]).first()
        if not user:
            new_uid = str(uuid.uuid4())
            token = f"test-{new_uid}"
            user = User(
                id=new_uid,
                firebase_uid=token, # Set it HERE immediately
                first_name=t_user["first_name"],
                last_name=t_user["last_name"],
                email=t_user["email"],
                role=t_user["role"],
                status="active"
            )
            db.add(user)
            db.commit()
            db.refresh(user)
        else:
            token = f"test-{user.id}"
            user.firebase_uid = token # Update existing
            db.commit()
        
        created[t_user["role"].value] = {"uuid": user.id, "token": token}
            
@router.get("/all-users")
def list_all_users_debug(db: Session = Depends(get_db)):
    users = db.query(User).all()
    return [{"id": u.id, "email": u.email, "firebase_uid": u.firebase_uid} for u in users]
