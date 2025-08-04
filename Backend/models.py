from sqlalchemy import Column, Integer, String
from database import Base

class User(Base):
    __tablename__ = "users"

    user_id: int = Column(Integer, primary_key=True, index=True)
    username: str = Column(String, index=True)
    user_hashed_password: str = Column(String)
