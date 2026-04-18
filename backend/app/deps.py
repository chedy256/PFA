from typing import Annotated
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


def get_current_user(authorization: Annotated[str, Header()], db: Annotated[Session, Depends(get_db)]):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing Bearer token")

    token = authorization.replace("Bearer ", "")
    
    # Debug/Test token bypass
    if token.startswith("test-"):
        uid = token.replace("test-", "")
    else:
        decoded = verify_firebase_token(token)
        uid = decoded["uid"]


    try:
        user = db.query(User).filter(User.firebase_uid == uid).first()
    except Exception:
        raise HTTPException(status_code=400, detail="Identifiant mal formé")

    if not user:
        raise HTTPException(status_code=401, detail="Utilisateur non enregistré")

    return user


def get_current_admin(user: Annotated[User, Depends(get_current_user)]):
    if user.role != "admin":
        raise HTTPException(status_code=403, detail="Admin access required")
    return user
