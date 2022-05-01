from gettext import find
from Backend.functions import forgotPasswordEmail, getToken, hashPassword, isStrongPassword, verifyPassword
from Backend.schemas import UserLogIn, UserSignUp
from fastapi import APIRouter, Body, status, Response
import pymongo


authRouter = APIRouter()
database = pymongo.MongoClient("mongodb+srv://saifelbob2002:huhqow-mekdeg-Nizhu2@cluster0.40yph.mongodb.net/oyp?retryWrites=true&w=majority")


@authRouter.post("/signup")
def SignUp(user_data: UserSignUp, response: Response):

    for person in database['OYP']["Users"].find():
        if person['email'] == user_data.email:
            response.status_code = status.HTTP_409_CONFLICT
            return {"failure":"UserExists already"}

    if isStrongPassword(user_data.password):
        user_data.password = hashPassword(user_data.password)
        data = database["OYP"]['Users'].insert_one(user_data.__dict__)
        return {"success":"User Created", "token":getToken({"data":str(data.inserted_id)})}
    else:
        response.status_code = status.HTTP_406_NOT_ACCEPTABLE
        return {"failure": "Weak password"}
        
        
@authRouter.post("/login")
def login(user : UserLogIn,response: Response):
    for data in database['OYP']["Users"].find():
        if user.email == data['email'] and verifyPassword(user.password, data["password"]):
            return {"success":"User Logged in", "token":getToken({"data":str(data['_id'])})}
    else: 
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure": "Wrong email or password"}

@authRouter.post("/forgotpassword")
def forgotPassword(response: Response, email: dict = Body(...)):
    for user in database['OYP']["Users"].find():
        if user['email'] == email['email']:
            return {"otp":str(forgotPasswordEmail(email['email']))}
    else:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"User doesn't exists"}