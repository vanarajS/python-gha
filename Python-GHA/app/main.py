from fastapi import FastAPI
from pydantic import BaseModel
from typing import List

app = FastAPI()

# Simple Data Model
class Product(BaseModel):
    id: int
    name: str
    price: float

# Mock Database
products = [
    {"id": 1, "name": "Mechanical Keyboard", "price": 99.99},
    {"id": 2, "name": "Wireless Mouse", "price": 49.99}
]

@app.get("/products", response_model=List[Product])
def get_products():
    return products

@app.get("/")
def health_check():
    return {"status": "online", "version": "1.0.0"}