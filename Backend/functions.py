from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from random import random, randrange
import smtplib
from jose import jwt
from passlib.context import CryptContext

#to check whether the password is strong or not
def isStrongPassword(password:str):
    isSpecialSymbolsIncluded = False
    for i in ["@", "!", "#", "$", "%", "^", "&", "*"]:
        if password.__contains__(i):
            isSpecialSymbolsIncluded = True

    if (password.__len__()>= 10) and (isSpecialSymbolsIncluded):
        return True

# tokenization function 
def getToken(payloads: dict):
    token = jwt.encode(claims=payloads, key="saifIsAnNuStudent202003013", algorithm="HS256")
    return token

context = CryptContext(schemes=["bcrypt"], deprecated="auto")
#to hash the password
def hashPassword(password: str):
    return context.hash(password)

# to verify the password
def verifyPassword(password: str, hashedPassword: str) -> bool:
    return context.verify(password, hashedPassword)

#to send email to reset password 
def forgotPasswordEmail(sendTo: str):
    otp = randrange(11111, 999999)

    message = MIMEMultipart()

    message.add_header("From", "OYP")
    message.add_header("To", "you")
    message.add_header("Subject", "Verify your account")
    message.attach(MIMEText(
    """<img src="https://i.ibb.co/SyhTr57/oyp-black-white.png" alt="oyp-black-white" border="0" />
    <br/>
    <h2>Verify your account</h2>
    your OTP is:
    <h3>{}</h3>
    """.format(otp), "html"))

    server = smtplib.SMTP_SSL("smtp.gmail.com", 465)
    server.ehlo()
    server.login("saifelbob2002@gmail.com", "saif@2002")
    server.sendmail("Order Your Programs", sendTo, message.as_string())
    return otp