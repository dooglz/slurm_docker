import pyslurm
import json
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return json.dumps(pyslurm.node().get())
