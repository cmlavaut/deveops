from flask import Flask
from flask_bootstrap import Bootstrap


def create_app():
    app = Flask(__name__)
    app.static_folder = 'static'
    bootstrap = Bootstrap(app)
    return app