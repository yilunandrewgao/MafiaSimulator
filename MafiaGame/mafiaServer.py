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
	isConnected = True

	userInfo = {"name":name, "sid": sid, "isConnected": isConnected}
	playerList.append(userInfo)

	socketio.emit("roomListUpdate", json.dumps([room.toSimpleJSON for room in roomList], \
		cls = MafiaEncoder.SimpleMafiaEncoder))

@socketio.on('disconnect')
def on_disconnect():

@socketio.on('createRoom')
def on_create_room():
	pass

@socketio.on('deleteRoom')
def on_delete_room():
	pass

@socketio.on("connectUser")
def on_connect_user(clientNickname):

@socketio.on("exitUser")
def on_exit_user:

@socketio.on("userExitRoom")
def on_user_exit_room(roomName):


@socketio.on("userJoinRoom")
def on_user_join_room(roomName):



if __name__ == '__main__':
	socketio.run(app)
