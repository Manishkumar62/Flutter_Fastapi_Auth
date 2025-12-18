from fastapi import APIRouter, Depends, HTTPException
from schemas import LoginRequest, TokenResponse, RefreshRequest
from security import (
    decode_token,
    create_access_token,
    create_refresh_token,
    get_current_user,
)

router = APIRouter()

@router.post("/login", response_model=TokenResponse)
def login(data: LoginRequest):
    if data.username != "admin" or data.password != "admin":
        raise HTTPException(status_code=401, detail="Invalid credentials")

    return {
        "access_token": create_access_token({"sub": data.username}),
        "refresh_token": create_refresh_token({"sub": data.username}),
    }

@router.post("/refresh", response_model=TokenResponse)
def refresh_token(data: RefreshRequest):
    payload = decode_token(data.refresh_token)
    username: str | None = payload.get("sub")
    if username is None:
        raise HTTPException(status_code=401, detail="Invalid refresh token")

    return {
        "access_token": create_access_token({"sub": username}),
        "refresh_token": data.refresh_token,  # reuse refresh token
    }

@router.get("/me")
def read_me(current_user: str = Depends(get_current_user)):
    return {
        "username": current_user,
        "role": "admin"
    }
