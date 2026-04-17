from typing import Annotated
from fastapi import APIRouter, Depends, Header, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_db, get_current_user
from app.auth import verify_firebase_token
from app.models import User
from app.schemas import BootstrapRequest, UserOut, FCMTokenUpdate

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/bootstrap", response_model=UserOut)
def bootstrap(
    data: BootstrapRequest,
    authorization: Annotated[str, Header()],
    db: Annotated[Session, Depends(get_db)],
):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token manquant")

    token = authorization.replace("Bearer ", "")
    uid = verify_firebase_token(token)

    user = db.get(User, uid)
    if user:
        if data.fcm_token:
            user.fcm_token = data.fcm_token
        db.commit()
        db.refresh(user)
        return user

    if data.requested_role == "admin":
        raise HTTPException(status_code=403, detail="Création admin interdite")

    if data.requested_role == "student":
        role, status = "student", "active"
    elif data.requested_role == "teacher":
        role, status = "none", "pending"
    else:
        raise HTTPException(status_code=400, detail="Rôle invalide")

    new_user = User(
        id=uid,
        email="",
        first_name=data.first_name,
        last_name=data.last_name,
        role=role,
        status=status,
        requested_role=data.requested_role,
        fcm_token=data.fcm_token,
    )
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user


@router.get("/me", response_model=UserOut)
def me(user: Annotated[User, Depends(get_current_user)]):
    return user


@router.patch("/fcm-token")
def update_fcm_token(
    data: FCMTokenUpdate, user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(get_db)]
) -> dict[str, str]:
    user.fcm_token = data.fcm_token
    db.commit()
    return {"message": "FCM token mis à jour"}
