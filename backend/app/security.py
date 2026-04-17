from typing import Annotated
from app.models import User
from fastapi import Depends
from app.deps import get_current_user
from fastapi import HTTPException


def require_role(*roles):
    def checker(user: Annotated[User, Depends(get_current_user)]):
        if user.role not in roles:
            raise HTTPException(status_code=403, detail="Forbidden")
        return user

    return checker
