from fastapi.testclient import TestClient
from main import app

# Initialize the TestClient with the FastAPI app
client = TestClient(app)

def test_read_main():
    """Test the health check endpoint."""
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"status": "online", "version": "1.0.0"}

def test_get_products():
    """Test that the products list returns correctly."""
    response = client.get("/products")
    assert response.status_code == 200
    data = response.json()
    assert len(data) > 0
    assert data[0]["name"] == "Mechanical Keyboard"

def test_invalid_endpoint():
    """Test that a non-existent route returns 404."""
    response = client.get("/non-existent")
    assert response.status_code == 404