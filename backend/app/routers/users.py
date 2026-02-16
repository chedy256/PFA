from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from models import User
from schemas import UserOut
from deps import get_db, get_current_user

router = APIRouter(prefix="/users", tags=["users"])

@router.get("/me", response_model=UserOut)
def me(user = Depends(get_current_user)):
    return user
