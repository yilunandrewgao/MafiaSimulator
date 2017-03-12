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
playerToRoomMap = {}

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

	# send player info and roomList
	emit('SetPlayer', (newPlayer.toJSON(), \
	[room.toSimpleJSON() for room in roomList]))

@socketio.on('disconnect')
def on_disconnect():

	# find user that disconnected
	for player in playerList:
		if player.sid == request.sid:
			# check if player is in a room
			if player in playerToRoomMap:
				selectedRoom = playerToRoomMap[player]
				#remove player from room
				selectedRoom.removePlayer(player)
				#remove player from playerList
				playerList.remove(Player)
				#remove player from mapping
				del playerToRoomMap[player]

				#emit new info
				socketio.emit("roomUpdate", selectedRoom.toJSON(),selectedRoom.roomTag)
				socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])
				
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

	#Update player to room map
	playerToRoomMap[newRoom.owner] = newRoom

	# join room with owner's sid
	newRoom.roomTag = newRoom.owner.sid
	join_room(newRoom.roomTag)

	#emit roomUpdate and roomListUpdate

	socketio.emit("roomUpdate", newRoom.toJSON(), room = newRoom.roomTag)
	socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])



@socketio.on("userExitRoom")
def on_user_exit_room():
	# find player that exited room
	for player in playerList:
		if player.sid == request.sid:
			# check if player is in a room
			if player in playerToRoomMap:
				selectedRoom = playerToRoomMap[player]
				#remove player from room
				selectedRoom.removePlayer(player)

				#remove player from mapping
				del playerToRoomMap[player]

				#emit new info
				socketio.emit("roomUpdate", selectedRoom.toJSON(),selectedRoom.roomTag)
				socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])
				
			else:
				# if player is not in room, it's an error
				print("Error: " + player.name + " tried to exit room when not in a room.")
			break



@socketio.on("userJoinRoom")
def on_user_join_room(roomOwnerSid):
	
	thisPlayer = None
	# find player object
	for player in playerList:
		if player.sid == request.sid:
			thisPlayer = player
			break

	if thisPlayer:
		#find room object
		for room in roomList:
			if room.roomTag = roomOwnerSid:
				# add player to the room
				room.addPlayer(thisPlayer)
				join_room(roomOwnerSid)
				playerToRoomMap[thisPlayer] = room
				

				#emit updates

				socketio.emit("roomUpdate", room.toJSON(),roomOwnerSid)
				socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])

				break


	



if __name__ == '__main__':
	socketio.run(app, host = "10.110.192.239", port = 7777)
