from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit

app = Flask(__name__)
socketio = SocketIO(app)

userList = []


@socketio.on('connect')
def connect():
	print("a player connected")

    @socketio.on('disconnect')
    def disconnect():
        print("a player disconnect")

        playerUsername = ""
        for user in userList:
        	if (user["id"] == request.sid):
        		user["isConnected"] = False;
        		playerUsername = user["username"]
        		break
        


if __name__ == '__main__':
	socketio.run(app)
