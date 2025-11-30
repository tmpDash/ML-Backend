from fastapi import APIRouter, HTTPException, status
from app.schemas.auth import LoginRequest, TokenResponse
from app.core.security import verify_password, create_access_token, ACCESS_TOKEN_EXPIRE_MINUTES
from datetime import timedelta

router = APIRouter()

# Simulamos un usuario en base de datos
fake_user = {
    "username": "kenny",
    "hashed_password": "$2b$12$vMP2wpuv21Cr7mtCd7AA2eVLMt07trRHcR3wWtyRoGfTXY4NWgqwq"
    # password: "123456"
}

@router.post("/login", response_model=TokenResponse)
def login(data: LoginRequest):
    if data.username != fake_user["username"]:
        raise HTTPException(status_code=400, detail="Usuario no encontrado")

    if not verify_password(data.password, fake_user["hashed_password"]):
        raise HTTPException(status_code=400, detail="Credenciales inválidas")

    access_token = create_access_token(
        data={"sub": data.username},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES),
    )

    return TokenResponse(access_token=access_token)
