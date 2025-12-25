"""App package initializer.

This file allows `app` to be imported as a package (so
`uvicorn app.main:app` works when run from the project root).
"""

__all__ = ["main", "models", "routes"]
