import firebase_admin
from firebase_admin import auth, credentials
from fastapi import HTTPException
import os

if not firebase_admin._apps:
    firebase_cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH", "firebase.json")
    cred = credentials.Certificate(firebase_cred_path)
    firebase_admin.initialize_app(cred)


def verify_firebase_token(token: str) -> str:
    try:
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
