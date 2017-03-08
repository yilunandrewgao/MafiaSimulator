from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit
from Player import Player
from Room import Room

app = Flask(__name__)
socketio = SocketIO(app)


roomDict = {}
playerLookupDict = {}


@socketio.on('connect')
def on_connect():
	print("a player connected")

@socketio.on('disconnect')
def on_disconnect():
    # check if player has already logged in
    if request.sid in playerLookupDict:
    	print(playerLookupDict[request.sid], " disconnected")

    else:
    	print("a un-logged-in player has disconnected")

@socketio.on('createRoom')
def on_create_room():
	pass

@socketio.on('deleteRoom')
def on_delete_room():
	pass

@socketio.on("connectUser")
def on_connect_user(clientNickname):
	# message = "User " + clientNickname + " has connected. "
	# print(message)


	# userInfo = {}
	# foundUser = False
	# for user in userList:
	# 	if (user["nickname"] == clientNickname):
	# 		user["isConnected"] = True
	# 		user["id"] = request.sid
	# 		userInfo = user
	# 		foundUser = True
	# 		break

	# if (not foundUser):
	# 	userInfo["id"] = request.sid
	# 	userInfo["nickname"] = clientNickname
	# 	userInfo["isConnected"] = True
	# 	userList.append(userInfo)

	# socketio.emit("userList", userList)
	# socketio.emit("userConnectUpdate", userInfo)

	# print("connectUser-userList: ",  userList)

@socketio.on("exitUser")
def on_exit_user:

@socketio.on("userExitRoom")
def on_user_exit_room(roomName):


@socketio.on("userJoinRoom")
def on_user_join_room(roomName):



if __name__ == '__main__':
	socketio.run(app)
