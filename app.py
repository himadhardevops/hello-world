from datetime import datetime
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello_world():
    now = datetime.now()
    return f'Hello, World! The time is {now}.'

if __name__ == '__main__':
    app.run()
