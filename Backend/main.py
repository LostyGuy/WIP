import uvicorn
from fastapi import FastAPI

class GameBackend:
    def __init__(self):
        self.app = FastAPI(title="Game Backend API")
        self.root_site()

    def root_site(self):
        @self.app.get("/")
        async def root() -> None:
            return {"NonE":"NonE"}


if __name__ == "__main__":
    uvicorn.run(GameBackend().app, port=8000, host="0.0.0.0")