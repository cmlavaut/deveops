from flask import Blueprint, render_template, redirect, url_for, request, flash
from werkzeug.security import generate_password_hash, check_password_hash
from wtforms.fields import StringField, DateField,PasswordField, SubmitField
from wtforms.validators import DataRequired, Email
from .models import UserData, UserModel
from .database import get_user, user_put
from flask_login import login_user, logout_user, login_required
from flask_wtf import FlaskForm


auth = Blueprint('auth', __name__)

class UserForm(FlaskForm):
    name = StringField ("Name", validators= [DataRequired()])
    email = StringField ("Email", validators= [DataRequired()])
    username = StringField ("Username", validators= [DataRequired()])
    password = PasswordField ("Password", validators= [DataRequired()])
    submit= SubmitField("Aceptar")

class NameForm(FlaskForm):
    username = StringField ("Username", validators= [DataRequired()])
    password = PasswordField("Password", validators= [DataRequired()])
    submit= SubmitField("Aceptar")

@auth.route('/login', methods=['GET', 'POST'])
def login():
    context = {
        'username': None,
        'passsword': None
    }
  
    form = NameForm()
    if form.validate_on_submit(): #aqui estoy validando que tenga el texto lleno con algo
        username = form.username.data
        password= form.password.data
        user = get_user(username)
        print(user)
        if not user.empty:
            name = user['name'][0]
            email = user['email'][0]
            print(check_password_hash(user['password'][0], password))
            if check_password_hash(user['password'][0], password):
                user_data = UserData(username,password,name,email)
                user = UserModel(user_data)
                flash('Bienvenido de nuevo')
                login_user(user)
                return redirect(url_for('user'))
            else:
                flash('Please check your login details and try again')

        else:
            flash('Usuario no existe')
            return redirect(url_for('auth.signup'))
            form.username.data = ''
            form.password.data = ''

    return render_template("login.html", **context, form= form)

@auth.route('/signup', methods=['GET', 'POST'])
def signup():
    dicc = {
        'name': None,
        'email': None,
        'username': None,
        'password': None
    }
    form = UserForm()

    if form.validate_on_submit(): #aqui estoy validando que tenga el texto lleno con algo
        name= form.name.data
        email= form.email.data
        username = form.username.data
        password = form.password.data
        
        user = get_user(username)
        if user.empty:
            passsword_hash = generate_password_hash(password)
            user_data= UserData(username,passsword_hash, name, email) 
            user_put(user_data)
            user = UserModel(user_data)
            login_user(user)
            return redirect(url_for('index'))
        else:
            flash("El usuario ya existe")
            form.name.data = '' #limpiar el box 
            form.email.data = ''
            form.username.data = ''
            form.password.data = ''   
    return render_template ("signup.html", form = form,**dicc)



@auth.route('/logout')
@login_required
def logout():
    logout_user()
    flash("Regresa pronto")
    return redirect(url_for('index'))