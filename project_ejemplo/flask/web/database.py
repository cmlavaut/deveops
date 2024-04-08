import mysql.connector
from flask import request
import time
import pandas as pd
import os

variable = os.environ.get("host", "10.10.0.6")

db = mysql.connector.connect(
    host= variable,
    user="root",
    password="cmlavaut96*",
    database="usuarios"
)
def user_put(userdata):
    with open ('./web/bd/insertar.sql', 'r') as sql:
        comando_sql = sql.read()
        cursor = db.cursor()
        valor = (userdata.name, userdata.email, userdata.username, userdata.password)
        cursor.execute(comando_sql, valor)
        db.commit()
        cursor.close()

def get_user(id):
    with open ('./web/bd/consulta.sql', 'r') as sql:
        comando_sql = sql.read()
        cursor = db.cursor()
        try:
            cursor.execute(comando_sql.format(str(id)))
            consulta = cursor.fetchall()[0]
            user_ref = {
                'username' : [consulta[2]],
                'password' : [consulta[3]],
                'name' : [consulta[0]],
                'email' : [consulta[1]]
            }
            resultado = pd.DataFrame(user_ref)
            cursor.close()
        except:
            user_ref = {
                'username' : [],
                'password' : [],
                'name' : [],
                'email' : []
            }
            resultado = pd.DataFrame(user_ref)
        return resultado 



    




