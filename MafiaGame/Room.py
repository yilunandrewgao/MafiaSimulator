import json
from Player import Player

class Room:

	playerList = []
	roomName = None
	password = None
	maxPlayers = 0
	owner = None

	def __init__(self, roomName, password, maxPlayers, owner):
		self.roomName = roomName
		self.password = password
		self.maxPlayers = maxPlayers
		self.owner = owner
		self.playerList = [owner]

	def addPlayer(self, newPlayer):

		if len(playerList) < self.maxPlayers:
			self.playerList.append(newPlayer)
			return True

		else:
			return False

	def removePlayer(self, playerToBeRemoved):

		if playerToBeRemoved in playerList:
			playerList.remove(playerToBeRemoved)
			return True

		else: 
			return False

	def toJSON(self):

		infoDict = {"playerList": self.playerList, "roomName": self.roomName, "password": self.password\
		, "maxPlayers": self.maxPlayers, "owner": self.owner}

		return json.dumps(infoDict, default = lambda o: o.__dict__)


room1 = Room("test","test", 5, Player("bob","1"))
room2 = Room("room","password",6,Player("hello","2"))

print (room1.toJSON())
print (room2.toJSON())
