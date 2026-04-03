import uuid
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.deps import get_db, get_current_user
from app.models import Message
from app.schemas import MessageCreate, MessageOut

router = APIRouter(prefix="/messages", tags=["messaging"])


@router.post("/", response_model=MessageOut)
def send_message(
    data: MessageCreate, user=Depends(get_current_user), db: Session = Depends(get_db)
):
    msg = Message(
        id=str(uuid.uuid4()),
        sender_id=user.id,
        receiver_id=data.receiver_id,
        content=data.content,
    )
    db.add(msg)
    db.commit()
    db.refresh(msg)
    return msg


@router.get("/", response_model=list[MessageOut])
def get_my_messages(user=Depends(get_current_user), db: Session = Depends(get_db)):
    return db.query(Message).filter(Message.receiver_id == user.id).all()


@router.get("/conversation/{other_user_id}", response_model=list[MessageOut])
def get_conversation(
    other_user_id: str, user=Depends(get_current_user), db: Session = Depends(get_db)
):
    messages = (
        db.query(Message)
        .filter(
            ((Message.sender_id == user.id) & (Message.receiver_id == other_user_id))
            | ((Message.sender_id == other_user_id) & (Message.receiver_id == user.id))
        )
        .order_by(Message.created_at)
        .all()
    )
    return messages
