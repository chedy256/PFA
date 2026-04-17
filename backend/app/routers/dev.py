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
        existing = db.query(User).filter(User.email == t_user["email"]).first()
        if existing:
            token = f"test-{existing.id}"
            created[t_user["role"].value] = {"uuid": str(existing.id), "token": token}
        else:
            new_uid = uuid.uuid4()
            user = User(
                id=str(new_uid),
                first_name=t_user["first_name"],
                last_name=t_user["last_name"],
                email=t_user["email"],
                role=t_user["role"],
            )
            db.add(user)
            db.commit()
            db.refresh(user)
            token = f"test-{user.id}"
            created[t_user["role"].value] = {"uuid": str(user.id), "token": token}
            
    return {"message": "Test users seeded", "tokens": created}
