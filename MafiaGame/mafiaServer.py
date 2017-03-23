from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit, join_room, leave_room, close_room
from Player import Player
from Room import Room
import MafiaEncoder
import json

app = Flask(__name__)
socketio = SocketIO(app)


roomList = []
playerList = []
playerToRoomMap = {}


# room1 = Room("room1","password1",5,Player("Alice",1))

# room2 = Room("room2","password2",5,Player("Bob",2))

# room1.addPlayer(Player("Carol",3))

# roomList = [room1,room2]


def user_exit_room(player):
	selectedRoom = playerToRoomMap[player]

	#remove player from room
	selectedRoom.removePlayer(player)

	#remove player from mapping
	del playerToRoomMap[player]


	#emit new info to everyone except exiting user
	socketio.emit("roomUpdate", selectedRoom.toJSON(),room = selectedRoom.roomTag, skip_sid = request.sid)
	socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])

	#emit quitRoomUpdate to exiting user
	socketio.emit("quitRoomUpdate", room = request.sid)

	#remove player from socketio room
	leave_room(selectedRoom.roomTag)

def delete_room_of(player):
	roomToDelete = playerToRoomMap[player]
	#remove all players in room
	for player in roomToDelete.playerList:
		roomToDelete.removePlayer(player)
		#remove player from the mapping
		del playerToRoomMap[player]
	#remove room
	roomList.remove(roomToDelete)
	

	print("roomList: ", roomList)

	socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])
	socketio.emit("quitRoomUpdate", room = roomToDelete.roomTag)

	#remove socketio room
	close_room(roomToDelete.roomTag)




def reset_vote_count(player):
	#return dictionary of alive players and reset votes to 0

	#get room player is mappend to
	inRoom = playerToRoomMap[player]
	#create an empty dictionary {"sid":votes}
	votes = {}
	#fill votes dictionary
	for player in inRoom.playerList:
		#set player's voteFor to None
		player.voteFor = None
		if player.isAlive:
			votes[player.sid] = 0

	return votes



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

				if player == playerToRoomMap[player].owner:
					delete_room_of(player)
				else:
					#check if game started
					if playerToRoomMap[player].gameStarted:
						#not owner: set player status to offline
						player.isOnline = False
					else:
						user_exit_room(player)

				print (player.name + " disconnected")
				#remove player from playerList
				playerList.remove(player)
				
			else:
				# remove player from playerList
				print (player.name + " disconnected")
				playerList.remove(player)
			break
	

@socketio.on('deleteRoom')
def on_delete_room():
	#get the player object 
	for player in playerList:
		if player.sid == request.sid:
			#find the room the player is in
			if player in playerToRoomMap:
				
				delete_room_of(player)

				break



@socketio.on("createRoom")
def on_create_room(roomDict):
	newRoom = Room.fromDict(roomDict)

	# reset the owner so it's the same object as the player in playerList
	for player in playerList:
		if player.sid == newRoom.owner.sid:
			newRoom.owner = player
			newRoom.playerList = [player]
			break

	print(newRoom)
	roomList.append(newRoom)

	#Update player to room map
	playerToRoomMap[newRoom.owner] = newRoom

	# join socketio room with room name as tag
	newRoom.roomTag = newRoom.roomName
	join_room(newRoom.roomTag)

	#emit roomUpdate and roomListUpdate

	socketio.emit("roomUpdate", newRoom.toJSON(), room = newRoom.roomTag)
	socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])

	#emit hostRoomUpdate to increment hosted room data 
	socketio.emit("hostedRoomUpdate", room = request.sid)



@socketio.on("userExitRoom")
def on_user_exit_room():
	# find player that exited room
	for player in playerList:
		if player.sid == request.sid:
			# check if player is in a room
			print (playerToRoomMap)
			if player in playerToRoomMap:
				if player == playerToRoomMap[player].owner:
					delete_room_of(player)
				else:
					user_exit_room(player)
				
			else:
				# if player is not in room, it's an error
				print("Error: " + player.name + " tried to exit room when not in a room.")
			break



@socketio.on("userJoinRoom")
def on_user_join_room(roomTag):
	
	thisPlayer = None
	# find player object
	for player in playerList:
		if player.sid == request.sid:
			thisPlayer = player
			print (thisPlayer)
			break

	if thisPlayer:
		#find room object
		for room in roomList:
			if room.roomTag == roomTag:
				print (room)
				# add player to the room
				room.addPlayer(thisPlayer)
				join_room(roomTag)
				playerToRoomMap[thisPlayer] = room
				

				#emit updates

				socketio.emit("roomUpdate", room.toJSON(), room = roomTag)
				socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])

				break

@socketio.on("postMessage")
def on_post_message(message):

	for player in playerList:
		if player.sid == request.sid:
			socketio.emit("postMessageUpdate", {"player": player.name, "message": message})
			break

		
@socketio.on("startGame")
def on_start_game():
	#find player in playerList
	for player in playerList:
		if player.sid == request.sid:
			#find room player is mapped to
			roomToStart = playerToRoomMap[player]
			#lock room player is in
			roomToStart.gameStarted = True
			#assign roles to players in room
			roomToStart.assignRoles()

			#emit roomList update to everyone
			socketio.emit("roomListUpdate", [room.toSimpleJSON() for room in roomList])
			#emit startGame update to each player
			for player in roomToStart.playerList:
				socketio.emit("startGameUpdate", player.role, room = player.sid)
				print("player: ", str(player), "role: ", player.role)
			

			break



@socketio.on("startRound")
def on_start_round():
	#find player in playerList
	for player in playerList:
		if player.sid == request.sid:
			#find room player is mapped to
			inRoom = playerToRoomMap[player]
			#check to see if anyone side won
			whoWon = inRoom.whoWon()
			#if no one has yet to win
			if whoWon == None:
				#get alive players list
				alivePlayersList = inRoom.alivePlayers()
				print("alive players: ", [str(player) for player in alivePlayersList])
				#get vote count set to 0
				voteCountReset = reset_vote_count(player)
				print("vote reset: ", voteCountReset)
				#emit update: AliveList
				socketio.emit("startRoundUpdate", [player.toJSON() for player in alivePlayersList], room = inRoom.roomTag)
				#emit update: voteCount reset
				socketio.emit("votedForUpdate", voteCountReset, room = inRoom.roomTag)

				break

			else:

				#emit end game update and the side that won
				print("game over")
				print(whoWon, " won")
				socketio.emit("endGameUpdate", whoWon, room = inRoom.roomTag)


				


@socketio.on("votedFor")			
def on_voted_for(chosenPlayerSid, time):
	#check if night or day
	if time == "night":
		for player in playerList:
			#find player
			if player.sid == request.sid:
				#find room player is in
				if player in playerToRoomMap:
					inRoom = playerToRoomMap[player]
					
					#set the player's votedFor to chosen layer
					player.voteFor = chosenPlayerSid

					#update current vote count (this is a dictionary {"sid":1})
					currentVotes = inRoom.countVotes()

					#emit table update for chosen Player has been votedFor
					#socketio.emit("alivePlayerListUpdate", ???) 
					#write code here
					socketio.emit("votedForUpdate", currentVotes, room = inRoom.roomTag)

					#keep track if all mafiaVoted
					allMafiaVoted = True
					#check to see if all mafia members voted:
					for player in inRoom.playerList:
						#check to see if player is mafia and is online
						if (player.role == "mafia") and (player.isOnline) and (player.isAlive):
							if player.voteFor == None:
								allMafiaVoted = False
								break

					#emit to client
					if allMafiaVoted:
						#find who got the most votes:
						playerToKillSid = max(currentVotes, key=lambda key: currentVotes[key])
						#set chosenPlayer status (isAlive) as dead (false)
						inRoom.killPlayer(playerToKillSid)

						#emit who died
						socketio.emit("killedUpdate", playerToKillSid, room = inRoom.roomTag)
						
						#emit something
						break

				else:
					#player not in any room
					print(player.name, " is not in any room")
					break

	#if time is day
	else:
		for player in playerList:
			#find player
			if player.sid == request.sid:
				#find room player is in
				if player in playerToRoomMap:
					inRoom = playerToRoomMap[player]
					
					#set the player's votedFor to chosen player sid
					player.voteFor = chosenPlayerSid

					#update current vote count
					currentVotes = inRoom.countVotes()

					#emit table update for chosen Player has been votedFor
					#socketio.emit("alivePlayerListUpdate", ???)  
					#write code here
					socketio.emit("votedForUpdate", currentVotes, room = inRoom.roomTag)

					#keep track if all player voted
					allPlayersVoted = True
					#keep track to see if all players voted
					for player in inRoom.playerList:
						if player.isOnline and player.isAlive:
							if player.voteFor == None:
								allPlayersVoted = False
								break

					#emit to client
					if allPlayersVoted:
						#find who got the most votes:
						playerToKillSid = max(currentVotes, key=lambda key: currentVotes[key])
						#set chosenPlayer status (isAlive) as dead (false)
						inRoom.killPlayer(playerToKillSid)
						#emit who died
						socketio.emit("killedUpdate", playerToKillSid, room = inRoom.roomTag)
						#emit something
						break
				else:
					print(player.name, " is not in any room")
					break







if __name__ == '__main__':
	socketio.run(app, host = "192.168.1.15", port = 7777)

