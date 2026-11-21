import getpass
import hashlib
import os
from pathlib import Path
import secrets
import sqlite3
import sys
import time
from contextlib import contextmanager

from argon2 import PasswordHasher
from argon2.exceptions import VerifyMismatchError

hasher = PasswordHasher()

if __name__ == "__main__" and sys.argv[1:] == ["hash-password"]:
    password = getpass.getpass("Mot de passe Homepage : ")
    if len(password) < 16 or password != getpass.getpass("Confirmation : "):
        sys.exit("Utilise au moins 16 caractères et saisis deux fois le même mot de passe.")
    print(hasher.hash(password))
    sys.exit(0)

from flask import Flask, abort, redirect, render_template_string, request

host = os.environ["HOMEPAGE_PUBLIC_HOST"]
password_hash = (Path(os.environ["CREDENTIALS_DIRECTORY"]) / "password-hash").read_text().strip()
database_path = Path(os.environ["STATE_DIRECTORY"]) / "sessions.sqlite3"
cookie_name = "__Host-homepage-session"
lifetime = 24 * 60 * 60

app = Flask(__name__)
app.config.update(TRUSTED_HOSTS=[host], MAX_CONTENT_LENGTH=4096)


@contextmanager
def database():
    connection = sqlite3.connect(database_path)
    try:
        with connection:
            yield connection
    finally:
        connection.close()


with database() as connection:
    connection.execute(
        "CREATE TABLE IF NOT EXISTS sessions (token TEXT PRIMARY KEY, expires INTEGER NOT NULL)"
    )


def token_digest(token):
    return hashlib.sha256(f"{password_hash}:{token}".encode()).hexdigest()


@app.after_request
def protect_response(response):
    response.headers["Cache-Control"] = "no-store"
    response.headers["Content-Security-Policy"] = (
        "default-src 'none'; style-src 'unsafe-inline'; form-action 'self'; "
        "frame-ancestors 'none'; base-uri 'none'"
    )
    return response


def page(action, error=False):
    return render_template_string(
        """<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{{ title }} · Raph's Server</title>
<style>
  :root { color-scheme: dark; font: 1rem system-ui; }
  body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: #10141c; }
  main { width: min(22rem, 85vw); padding: 1.5rem; background: #1c2330; border-radius: 1rem; }
  label, input, button { display: block; margin-top: .65rem; }
  input, button { box-sizing: border-box; width: 100%; padding: .65rem; font: inherit; }
  a { color: #b9d5ff; }
</style>
<main>
  <h1>{{ title }}</h1>
  {% if error %}<p role="alert">Identifiant ou mot de passe incorrect.</p>{% endif %}
  <form method="post" action="/{{ action }}">
    {% if action == "login" %}
    <label for="username">Identifiant</label>
    <input id="username" name="username" autocomplete="username" required>
    <label for="password">Mot de passe</label>
    <input id="password" name="password" type="password" autocomplete="current-password" required>
    {% endif %}
    <button>{{ title }}</button>
  </form>
  {% if action == "logout" %}<p><a href="/">Retour au tableau de bord</a></p>{% endif %}
</main>
""",
        action=action,
        title="Se connecter" if action == "login" else "Se déconnecter",
        error=error,
    )


@app.route("/login", methods=["GET", "POST"])
def login():
    if request.method == "GET":
        return page("login")
    if request.headers.get("Origin") != f"https://{host}":
        abort(403)

    password = request.form.get("password", "")
    try:
        hasher.verify(password_hash, password)
    except VerifyMismatchError:
        return page("login", error=True), 401
    if request.form.get("username") != "raph":
        return page("login", error=True), 401

    token = secrets.token_urlsafe(32)
    now = int(time.time())
    previous = request.cookies.get(cookie_name)
    with database() as connection:
        connection.execute("DELETE FROM sessions WHERE expires <= ?", (now,))
        if previous:
            connection.execute("DELETE FROM sessions WHERE token = ?", (token_digest(previous),))
        connection.execute(
            "INSERT INTO sessions VALUES (?, ?)", (token_digest(token), now + lifetime)
        )

    response = redirect("/", code=303)
    response.set_cookie(
        cookie_name, token, max_age=lifetime, secure=True, httponly=True, samesite="Lax"
    )
    return response


@app.get("/verify")
def verify():
    token = request.cookies.get(cookie_name)
    if token:
        with database() as connection:
            row = connection.execute(
                "SELECT 1 FROM sessions WHERE token = ? AND expires > ?",
                (token_digest(token), int(time.time())),
            ).fetchone()
        if row:
            return "", 204
    return "", 401


@app.route("/logout", methods=["GET", "POST"])
def logout():
    if request.method == "GET":
        return page("logout")
    if request.headers.get("Origin") != f"https://{host}":
        abort(403)

    token = request.cookies.get(cookie_name)
    if token:
        with database() as connection:
            connection.execute("DELETE FROM sessions WHERE token = ?", (token_digest(token),))
    response = redirect("/login", code=303)
    response.delete_cookie(cookie_name, secure=True, httponly=True, samesite="Lax")
    return response


if __name__ == "__main__":
    from waitress import serve

    serve(app, host="127.0.0.1", port=8083, threads=2, max_request_body_size=4096)
