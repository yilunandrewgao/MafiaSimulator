from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit, join_room, leave_room
from Player import Player
from Room import Room
import MafiaEncoder
import json

app = Flask(__name__)
socketio = SocketIO(app)


roomList = []
playerList = []

room1 = Room("room1","password1",5,Player("Alice",1))

room2 = Room("room2","password2",5,Player("Bob",2))

room1.addPlayer(Player("Carol",3))

roomList = [room1,room2]



@socketio.on('connect')
def on_connect():
	pass




@socketio.on("setPlayer")
def on_set_player(name):

	print(name + " connected")

	sid = request.sid
	# create new player and add to list
	newPlayer = Player(name, sid)
	playerList.append(newPlayer)

	# newPlayerJSON = json.dumps(newPlayer, cls = MafiaEncoder.MafiaEncoder)
	# roomListJSON = json.dumps(roomList, cls = MafiaEncoder.SimpleMafiaEncoder)

	# send player info and roomList
	emit('SetPlayer', (newPlayer.toJSON(), \
	[room.toSimpleJSON() for room in roomList]))

@socketio.on('disconnect')
def on_disconnect():

	# find user that disconnected
	for player in playerList:
		if player.sid == request.sid:
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

@socketio.on("createRoom")
def on_create_room(roomDict):
	newRoom = Room.fromDict(roomDict)
	print(newRoom)
	roomList.append(newRoom)



@socketio.on("userExitRoom")
def on_user_exit_room(roomName):
	pass


@socketio.on("userJoinRoom")
def on_user_join_room(roomName):
	pass



if __name__ == '__main__':
	socketio.run(app, host = "192.168.1.15", port = 7777)
