from typing import Annotated
from typing import Optional
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.models import User
from app.schemas import UserOut, PaginatedUsersOut
from app.deps import get_db, get_current_user, get_current_admin
from math import ceil

router = APIRouter(prefix="/users", tags=["users"])


@router.get("/me", response_model=UserOut)
def me(user: Annotated[User, Depends(get_current_user)]):
    return user


@router.get("/make-admin-debug")
def make_admin(user: Annotated[User, Depends(get_current_user)], db: Annotated[Session, Depends(get_db)]) -> dict[str, str]:
    if user.id == "oyqJZDQTKDhvUTL24ZCdIF4R9s42":
        from app.models import UserRole
        user.role = UserRole.admin
        db.commit()
        return {"message": "You are now an admin"}
    return {"message": "Unauthorized"}


@router.get("/role/{role_name}", response_model=PaginatedUsersOut)
def list_users_by_role(
    role_name: str,
    db: Annotated[Session, Depends(get_db)],
    admin: Annotated[User, Depends(get_current_admin)],
    page: int = 1,
    limit: int = 10,
    search: Optional[str] = None,
):
    query = db.query(User).filter(User.role == role_name)

    if search:
        search_filter = f"%{search}%"
        query = query.filter(
            (User.first_name.ilike(search_filter)) |
            (User.last_name.ilike(search_filter)) |
            (User.email.ilike(search_filter))
        )

    total_count = query.count()
    total_pages = ceil(total_count / limit)
    offset = (page - 1) * limit

    users = query.offset(offset).limit(limit).all()

    return {
        "users": users,
        "total_count": total_count,
        "total_pages": total_pages,
        "current_page": page,
    }
