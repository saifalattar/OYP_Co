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

class Application(pydantic.BaseModel):
    name: str
    description: str
    price: float
    images: list
    likes: int
    
class Application_From_Database(Application):
    _id: str

class Design(pydantic.BaseModel):
    title: str
    image: str
    artist: str
    link: str