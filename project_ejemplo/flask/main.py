from flask import render_template
from flask_login import login_required, current_user
from web import create_app

app = create_app()

@app.route('/')
def index():
    return render_template('main.html')
    
@app.route('/user', methods = ['GET', 'POST'])
@login_required
def user():
    username = current_user.id
    context = {
        'username' : username
    }
    return render_template('user.html', **context)

@app.errorhandler(404)
def pagenotfound(error):
    return render_template('404.html'), 404


@app.errorhandler(500)
def pagenotfound(error):
    return render_template('500.html'), 500

if __name__ == '__main__':
    app.run(host= '0.0.0.0',port= 5010, debug= True)
