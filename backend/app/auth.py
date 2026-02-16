import firebase_admin
from firebase_admin import auth, credentials
from fastapi import HTTPException

# Check if app is already initialized to avoid error on reload
if not firebase_admin._apps:
    cred = credentials.Certificate("firebase.json")
    firebase_admin.initialize_app(cred)

def verify_firebase_token(token: str) -> str:
    try:
        decoded = auth.verify_id_token(token)
        return decoded["uid"]
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid or expired token")
