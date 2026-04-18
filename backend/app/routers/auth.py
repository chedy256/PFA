from typing import Annotated
from fastapi import APIRouter, Depends, Header, HTTPException
from sqlalchemy.orm import Session
from app.deps import get_db, get_current_user
from app.auth import verify_firebase_token
from datetime import datetime, timezone
from app.models import User, UserRole, Device, Notification
from app.schemas import BootstrapRequest, UserOut, FCMTokenUpdate, DeviceCreate, NotificationOut

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/devices")
def register_device(
    data: DeviceCreate,
    user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
):
    # Find existing device in Python to avoid complex SQL JSON operators
    devices = db.query(Device).filter(Device.user_id == user.id).all()
    existing_device = None

    for d in devices:
        if data.fcm_token and d.fcm_token == data.fcm_token:
            existing_device = d
            break
        if data.web_subscription and d.web_subscription:
            if d.web_subscription.get("endpoint") == data.web_subscription.get("endpoint"):
                existing_device = d
                break

    if existing_device:
        existing_device.last_seen = datetime.now(timezone.utc)
        existing_device.is_active = True
    else:
        new_device = Device(
            user_id=user.id,
            platform=data.platform,
            fcm_token=data.fcm_token,
            web_subscription=data.web_subscription,
        )
        db.add(new_device)

    db.commit()
    return {"message": "Appareil enregistré"}


@router.post("/bootstrap", response_model=UserOut)
def bootstrap(
    data: BootstrapRequest,
    authorization: Annotated[str, Header()],
    db: Annotated[Session, Depends(get_db)],
):
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token manquant")

    token = authorization.replace("Bearer ", "")
    decoded = verify_firebase_token(token)
    uid = decoded["uid"]
    email = decoded.get("email", f"{uid}@placeholder.com")

    user = db.query(User).filter(User.firebase_uid == uid).first()
    if user:
        if data.fcm_token:
            user.fcm_token = data.fcm_token
        db.commit()
        db.refresh(user)
        return user

    if data.requested_role == "admin":
        # Allow admin bootstrap for development/test tokens, but block for real Firebase tokens
        if not token.startswith("test-"):
            raise HTTPException(status_code=403, detail="Création admin interdite")

    if data.requested_role == "student":
        role, status = UserRole.student, "active"
    elif data.requested_role == "teacher":
        role, status = UserRole.teacher, "pending"
    elif data.requested_role == "admin":
        role, status = UserRole.admin, "active"
    else:
        raise HTTPException(status_code=400, detail="Rôle invalide")

    new_user = User(
        firebase_uid=uid,
        email=email,
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


@router.post("/test-send")
def test_send_notification(
    data: dict,
    user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
):
    devices = db.query(Device).filter(Device.user_id == user.id, Device.is_active == True).all()
    if not devices:
        return {"message": "Aucun appareil actif trouvé pour cet utilisateur"}

    for device in devices:
        # Create a notification record for each device
        new_notif = Notification(
            user_id=user.id,
            title=data.get("title", "Test"),
            body=data.get("body", "Test Body"),
            data={"platform": device.platform},
            status="sent"  # In a real app, this would be set by a background worker after FCM success
        )
        db.add(new_notif)

    db.commit()
    return {"message": f"Notification envoyée à {len(devices)} appareils"}


@router.get("/notifications", response_model=list[NotificationOut])
def get_notifications(
    user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)]
):
    return db.query(Notification).filter(Notification.user_id == user.id).order_by(Notification.created_at.desc()).all()
