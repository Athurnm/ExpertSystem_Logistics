from flask import Flask,render_template, request,jsonify,Response
from clips import Environment

# Initiate the app of web server
app = Flask(__name__)

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/Questions")
def Questions():
    return "Is there any questions?"

if __name__ == "__main__":
    app.run(debug=True)
