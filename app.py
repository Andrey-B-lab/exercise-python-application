from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    return "It's a Flask application runnig on POD!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)
