import pydantic

class UserSignUp(pydantic.BaseModel):
    name: str
    email: str
    password: str
    orders: list = []
    likes: list = []

class UserLogIn(pydantic.BaseModel):
    email: str 
    password: str