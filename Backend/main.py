import uvicorn
from fastapi import FastAPI
from contextlib import asynccontextmanager
from database import Base, engine, SessionLocal
from models import User
import logging as log



def log_info(message) -> None:
    print("_" * 30)
    log.info(message)

@asynccontextmanager
async def lifespan(app: FastAPI):
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        if not db.query(User).first():
            users = [
                    User(username= "Kalifonix", user_hashed_password= "NotAnyMore"),
                    User(username= "Honda", user_hashed_password= "1234"),
               ]
            db.add_all(users)
            db.commit()
            log_info("Data Added Successfully")
        else:
            log_info("Data Already Added")
    except Exception as e:
        log_info(f"Error Occured During Data Initialization: {e}")
    yield
    db.close()

class GameBackend:
    def __init__(self):
        self.app = FastAPI(title="Game Backend API", lifespan=lifespan)
        self.root_site()

    def root_site(self) -> None:
        @self.app.get("/")
        async def root():
            db = SessionLocal()
            users = db.query(User).all()
            db.close()
            return [
                {"user_id": user.user_id, "username": user.username}
                for user in users
            ]
        
app = GameBackend().app

if __name__ == "__main__":
    uvicorn.run(app, port=8000, host="0.0.0.0")