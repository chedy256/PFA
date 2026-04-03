from fastapi import Depends, Header, HTTPException
from sqlalchemy.orm import Session
from app.database import SessionLocal
from app.auth import verify_firebase_token
from app.models import User


def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_current_user(authorization: str = Header(...), db: Session = Depends(get_db)):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing Bearer token")

    token = authorization.replace("Bearer ", "")
    uid = verify_firebase_token(token)

    user = db.get(User, uid)
    if not user:
        raise HTTPException(status_code=403, detail="User not registered")

    return user
