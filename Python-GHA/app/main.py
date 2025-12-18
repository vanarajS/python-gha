from fastapi import FastAPI
from .routes import router   # ← dot matters

app = FastAPI()
app.include_router(router)
