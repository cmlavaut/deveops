from flask import Flask
from flask_login import LoginManager
from .models import UserModel
from .auth import auth
from flask_bootstrap import Bootstrap
from .config import Config

login_manager = LoginManager()
login_manager.login_view = 'auth.login'

@login_manager.user_loader
def load_user(username):
    # since the user_id is just the primary key of our user table, use it in the query for the user
    return UserModel.query(username)


def create_app():
    app = Flask(__name__)
    app.static_folder = 'static'
    app.config.from_object(Config)
    bootstrap = Bootstrap(app)
    login_manager.init_app(app)
   # blueprint for auth routes in our app
    app.register_blueprint(auth)
    return app