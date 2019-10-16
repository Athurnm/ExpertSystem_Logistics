from flask import Flask,render_template, request,jsonify,Response
# from clips import Environment

# Initiate the app of web server
app = Flask(__name__)

# initiate and load expert system
# env = Environment()
# env.load("Rule.clp")

@app.route("/")
def home():
    return render_template("index.html")

@app.route("/questions")
def questions():
    return "Is there any questions?"

if __name__ == "__main__":
    app.run(debug=True)
