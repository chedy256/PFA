import firebase_admin
from firebase_admin import auth, credentials
from fastapi import HTTPException
import os

if not firebase_admin._apps:
    default_path = (
        "/etc/secrets/firebase.json"
        if os.path.exists("/etc/secrets/firebase.json")
        else "firebase.json"
    )
    firebase_cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH", default_path)
    # Check if file exists before initializing to allow local dev without firebase
    if os.path.exists(firebase_cred_path):
        cred = credentials.Certificate(firebase_cred_path)
        firebase_admin.initialize_app(cred)


def verify_firebase_token(token: str) -> str:
    # Allow test tokens for development
    if token.startswith("test-"):
        uid = token.replace("test-", "")
        return uid

    try:
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
