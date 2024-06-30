from http import HTTPStatus

import jwt
from fastapi import Header, HTTPException


def auth_middleware(x_auth_token=Header()):
    try:
        if not x_auth_token:
            raise HTTPException(
                HTTPStatus.UNAUTHORIZED.value, "No auth token, access denied!"
            )

        verified_token = jwt.decode(x_auth_token, "password_key", ["HS256"])

        if not verified_token:
            raise HTTPException(
                HTTPStatus.UNAUTHORIZED.value,
                "Token verification failed, authorization denied!",
            )

        uid = verified_token.get("id")
        return {"uid": uid, "token": x_auth_token}

    except jwt.PyJWTError:
        raise HTTPException(
            HTTPStatus.UNAUTHORIZED.value,
            "Token is not valid, authorization failed.",
        )
