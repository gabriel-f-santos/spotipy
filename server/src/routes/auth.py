import uuid
from http import HTTPStatus

import bcrypt
import jwt
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session, joinedload

from ..infra.database import get_db
from ..middlewares import auth_middleware
from ..models import User
from ..schemas import UserCreate, UserLogin

router = APIRouter()


@router.post("/signup", status_code=HTTPStatus.CREATED.value)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if user_db:
        raise HTTPException(
            HTTPStatus.BAD_REQUEST.value,
            "User with the same email already exists!",
        )

    hashed_pw = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(
        id=str(uuid.uuid4()),
        email=user.email,
        password=hashed_pw,
        name=user.name,
    )

    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post("/login")
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(
            HTTPStatus.BAD_REQUEST.value, "Email or password is incorrect!"
        )

    is_match = bcrypt.checkpw(user.password.encode(), user_db.password)

    if not is_match:
        raise HTTPException(
            HTTPStatus.BAD_REQUEST.value, "Email or password is incorrect!"
        )

    token = jwt.encode({"id": user_db.id}, "password_key")

    return {"token": token, "user": user_db}


@router.get("/")
def current_user_data(
    db: Session = Depends(get_db), user_dict=Depends(auth_middleware)
):
    user = (
        db.query(User)
        .filter(User.id == user_dict["uid"])
        .options(joinedload(User.favorites))
        .first()
    )

    if not user:
        raise HTTPException(HTTPStatus.BAD_REQUEST.value, "Invalid Data")

    return user
