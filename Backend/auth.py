from Backend.functions import forgotPasswordEmail, getToken, hashPassword, isStrongPassword, verificationEmail, verifyPassword
from Backend.schemas import UserLogIn, UserSignUp
from fastapi import APIRouter, Body, status, Response
import pymongo


authRouter = APIRouter()
database = pymongo.MongoClient("mongodb+srv://saifelbob2002:huhqow-mekdeg-Nizhu2@cluster0.40yph.mongodb.net/oyp?retryWrites=true&w=majority")


@authRouter.post("/signup")
def SignUp(user_data: UserSignUp, response: Response): 
    user_data.email = user_data.email.lower()
    try:
        user_data.password = hashPassword(user_data.password)
        data = database["OYP"]['Users'].insert_one(user_data.__dict__)
        return {"success":"User Created", "token":getToken({"data":str(data.inserted_id)})}
    except:
        response.status_code = status.HTTP_403_FORBIDDEN
        return {"failure":"there is something error try again later, or check your connection"}

        
        
@authRouter.post("/login")
def login(user : UserLogIn,response: Response):
    for data in database['OYP']["Users"].find():
        if user.email.lower() == data['email'].lower() and verifyPassword(user.password, data["password"]):
            return {"success":"User Logged in", "token":getToken({"data":str(data['_id'])})}
    else: 
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure": "Wrong email or password"}

@authRouter.post("/forgotpassword")
def forgotPassword(response: Response, email: dict = Body(...)):
    for user in database['OYP']["Users"].find():
        if user['email'].lower() == email['email'].lower():
            return {"otp":str(forgotPasswordEmail(email['email']))}
    else:
        response.status_code = status.HTTP_404_NOT_FOUND
        return {"failure":"User doesn't exists"}

@authRouter.post("/verifyuser")# this function happens before sign up
def verifyUser(response: Response, user: UserLogIn):
    if isStrongPassword(user.password):
            
        for person in database['OYP']["Users"].find():
            if person['email'] == user.email:
                response.status_code = status.HTTP_409_CONFLICT
                return {"failure":"UserExists already"}
        else:
            try: 
               return{"otp": verificationEmail(user.email)}
            except:
                response.status_code = status.HTTP_405_METHOD_NOT_ALLOWED
                return {"failure":"There is an error in email or check your connection"}
                
    else:
        response.status_code = status.HTTP_406_NOT_ACCEPTABLE
        return {"failure":"weak password it must be at least 10 characters with special symbols"}

@authRouter.put("/forgotpassword/changepassword")
def changePassword(user: UserLogIn,response:Response):
    if isStrongPassword(user.password):
        user.email = user.email.lower()
        user.password = hashPassword(user.password)
        database['OYP']["Users"].find_one_and_update({"email":user.email}, {"$set":{"password":user.password}})
        response.status_code = status.HTTP_201_CREATED
        return {"success": "Password updated"}
    else:
        return {"failure":"weak password it must be at least 10 characters with special symbols"}

######################### FINISHED ##############################