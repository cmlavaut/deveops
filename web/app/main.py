from flask import Flask, render_template, make_response
from data import create_app

app = create_app()

@app.route('/mostrarinfo/<parametro>', methods=['GET'])
def mostrarinfo(parametro):
    print(parametro)
    resp = make_response(render_template("visualizar.html", parametro = parametro))
    return resp


@app.route("/")
def home():
    return  render_template("index.html")


if __name__ == "__main__":
    app.run(debug=True, port=5020, host = "0.0.0.0")