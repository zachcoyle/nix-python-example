from dataclasses import dataclass

from flask import Flask

app = Flask(__name__)


@dataclass
class Blah:
    x: int


def x(a: Blah, b: Blah):
    return a.x + b.x


@app.route("/")
def hello_world():
    return "Hello, World!"


def main():
    app.run(use_reloader=False)
