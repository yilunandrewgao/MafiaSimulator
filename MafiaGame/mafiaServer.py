from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit

app = Flask(__name__)
socketio = SocketIO(app)

userList = []
roomList = []


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
    @socketio.on('createRoom')
    def createRoom():
    	pass

    @socketio.on("connectUser")
	def connectUser(clientNickname):
		message = "User " + clientNickname + " has connected. "
		print(message)


		userInfo = {}
		foundUser = False
		for user in userList:
			if (user["nickname"] == clientNickname):
				user["isConnected"] = True
				user["id"] = request.sid
				userInfo = user
				foundUser = True
				break

		if (not foundUser):
			userInfo["id"] = request.sid
			userInfo["nickname"] = clientNickname
			userInfo["isConnected"] = True
			userList.append(userInfo)

		socketio.emit("userList", userList)
		socketio.emit("userConnectUpdate", userInfo)

		print("connectUser-userList: ",  userList)


@socketio.on('message')
def handle_message(message):
	send(message)



if __name__ == '__main__':
	socketio.run(app)
