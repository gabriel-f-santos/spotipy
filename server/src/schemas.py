from pydantic import BaseModel


class UserLogin(BaseModel):
    email: str
    password: str


class UserCreate(UserLogin):
    name: str


class FavoriteSong(BaseModel):
    song_id: str
