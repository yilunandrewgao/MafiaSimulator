from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit
from Player import Player
from Room import Room
import MafiaEncoder
import json

app = Flask(__name__)
socketio = SocketIO(app)


roomList = []
playerList = []




@socketio.on('connect')
def on_connect():
	name = request.args["name"]
	sid = request.sid

	print(name + " connected")

	# create new player and add to list
	newPlayer = Player(name, sid)
	playerList.append(newPlayer)

	# send player info and roomList
	socketio.emit("SetPlayer", data = (json.dumps(newPlayer, cls = MafiaEncoder.MafiaEncoder), \
	json.dumps(roomList, cls = MafiaEncoder.SimpleMafiaEncoder)))


@socketio.on('disconnect')
def on_disconnect():

	# find user that disconnected
	for player in playerList:
		if player.sid == request.sid and player.name == request.args["name"]:
			# check if player is in a room
			if player.inRoom:
				# TODO: implement removing player from room and playerList and emit new info
				pass
			else:
				# remove player from playerList
				print (player.name + " disconnected")
				playerList.remove(player)
			break
	

@socketio.on('deleteRoom')
def on_delete_room():
	pass

@socketio.on("connectUser")
def on_connect_user(clientNickname):
	# message = "User " + clientNickname + " has connected. "
	# print(message)
	pass


@socketio.on("exitUser")
def on_exit_user():
	pass

@socketio.on("userExitRoom")
def on_user_exit_room(roomName):
	pass


@socketio.on("userJoinRoom")
def on_user_join_room(roomName):
	pass



if __name__ == '__main__':
	socketio.run(app, host = "10.111.193.140", port = 7777)
