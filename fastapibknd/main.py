from fastapi import FastAPI
from auth import router as auth_router

app = FastAPI(title="Flutter Auth Backend")

app.include_router(auth_router, prefix="/auth", tags=["auth"])
