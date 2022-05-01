import json
from fastapi import FastAPI ,status, APIRouter, Response
import pymongo
from Backend.functions import getToken, hashPassword, isStrongPassword
from Backend.schemas import UserSignUp
from Backend.auth import authRouter
from jose import jwt

oyp = FastAPI()
database = pymongo.MongoClient("mongodb+srv://saifelbob2002:huhqow-mekdeg-Nizhu2@cluster0.40yph.mongodb.net/oyp?retryWrites=true&w=majority")


@oyp.get('/oyp/{token}/{appId}')
def goToApp(token, appId, response:Response):
    isValidUser = False
    for user in database['OYP']['Users'].find():
        if str(user["_id"]) == jwt.decode(token, key="saifIsAnNuStudent202003013", algorithms="HS256")['data']:
            isValidUser = True
            print("________________sif_________________")
            break
    else:
        response.status_code = status.HTTP_401_UNAUTHORIZED
        return {"failure": "Can't access this content"}
    
    if isValidUser:
        for app in database['OYP']['apps'].find():
            if appId == str(app["_id"]):
                app["_id"] = str(app["_id"])
                return app
    
    


oyp.include_router(authRouter)
