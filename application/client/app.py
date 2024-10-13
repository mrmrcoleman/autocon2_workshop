from flask import Flask
import requests

app = Flask(__name__)

# The client endpoint which makes a call to the server
@app.route('/')
def ping_server():
    try:
        # Make a request to the server's /ping endpoint
        server_url = 'http://192.168.2.0:8080/ping'
        response = requests.get(server_url)

        # Check if the response was successful
        if response.status_code == 200:
            return f"Successfully pinged server at {server_url}", 200
        else:
            return f"Failed to ping server. Status code: {response.status_code}", 500
    except Exception as e:
        return f"Error occurred: {str(e)}", 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)