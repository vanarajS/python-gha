from fastapi import APIRouter
from app.models import todos

router = APIRouter()

@router.get("/todos")
def get_todos():
    return todos

@router.post("/todos")
def add_todo(todo: dict):
    todos.append(todo)
    return {"message": "Todo added"}
