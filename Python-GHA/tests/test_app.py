from fastapi.testclient import TestClient
from Python-GHA.app.main import app

client = TestClient(app)

def test_add_todo():
    response = client.post("/todos", json={"task": "CI Test"})
    assert response.status_code == 200

def test_get_todos():
    response = client.get("/todos")
    assert response.status_code == 200
