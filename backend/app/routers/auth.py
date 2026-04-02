import uuid
from fastapi import APIRouter, Depends, Header, HTTPException
from sqlalchemy.orm import Session
from deps import get_db, get_current_user
from auth import verify_firebase_token
from models import User
from schemas import BootstrapRequest, UserOut, FCMTokenUpdate

router = APIRouter(prefix="/auth", tags=["auth"])


@router.post("/bootstrap", response_model=UserOut)
def bootstrap(
    data: BootstrapRequest,
    authorization: str = Header(...),
    db: Session = Depends(get_db),
):
    """
    Appelé après la connexion Firebase.
    Crée l'utilisateur en base s'il n'existe pas encore,
    ou met à jour son fcm_token s'il existe déjà.
    """
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token manquant")

    token = authorization.replace("Bearer ", "")
    uid = verify_firebase_token(token)  # vérifie avec Firebase

    # Cherche l'utilisateur dans la base
    user = db.get(User, uid)

    if user:
        # Utilisateur déjà existant → juste mettre à jour le fcm_token
        if data.fcm_token:
            user.fcm_token = data.fcm_token
        db.commit()
        db.refresh(user)
        return user

    # Nouvel utilisateur → on le crée
    # Déterminer le rôle et statut selon le rôle demandé
    if data.requested_role == "admin":
        raise HTTPException(
            status_code=403, detail="Création admin interdite publiquement"
        )

    if data.requested_role == "student":
        role = "student"
        status = "active"
    elif data.requested_role == "teacher":
        role = "none"  # le teacher doit être approuvé par un admin
        status = "pending"
    else:
        raise HTTPException(status_code=400, detail="Rôle invalide")

    new_user = User(
        id=uid,
        email="",  # on peut récupérer l'email depuis le token si besoin
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
def me(user=Depends(get_current_user)):
    """
    Retourne le profil de l'utilisateur connecté.
    """
    return user


@router.patch("/fcm-token")
def update_fcm_token(
    data: FCMTokenUpdate, user=Depends(get_current_user), db: Session = Depends(get_db)
):
    """
    Met à jour le token FCM (notifications push) de l'utilisateur.
    """
    user.fcm_token = data.fcm_token
    db.commit()
    return {"message": "FCM token mis à jour"}
