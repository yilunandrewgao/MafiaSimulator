import json
from Player import Player
import MafiaEncoder
import math
from random import shuffle

class Room:

	playerList = []

	roomName = None
	password = None
	maxPlayers = 0
	owner = None
	gameStarted = False

	roomTag = None

	nightChat = None
	dayChat = None

	def __init__(self, roomName, password, maxPlayers, owner):
		self.roomName = roomName
		self.password = password
		self.maxPlayers = maxPlayers
		self.owner = owner
		self.playerList = [owner]
	

	#alternative init from dictionary
	@classmethod
	def fromDict(cls, roomDict):
		roomName = roomDict["roomName"]
		password = roomDict["password"]
		maxPlayers = roomDict["maxPlayers"]
		owner = Player.fromDict(roomDict["owner"])
		return cls(roomName, password, maxPlayers, owner)

	def __repr__(self):
		returnString = self.roomName+" by "+repr(self.owner)+": "+repr(len(self.playerList))+"/"+\
		repr(self.maxPlayers)+" Status: "+str(self.gameStarted)
		return returnString
	

	def addPlayer(self, newPlayer):

		if len(self.playerList) < self.maxPlayers:

			self.playerList.append(newPlayer)
	
			return True

		else:
			return False

	def removePlayer(self, playerToBeRemoved):

		if playerToBeRemoved in self.playerList:
			self.playerList.remove(playerToBeRemoved)
			return True

		else: 
			return False

	def killPlayer(self, playerToKill):
		if playerToKill.isAlive:
			playerToKill.isAlive = False
			return True
		else:
			return False

	def assignRoles(self):
		playerCount = len(self.playerList)
		numMafia = int(round(math.sqrt(playerCount)))
		villagerCount = playerCount-numMafia

		roleList = []

		#append "mafia" role into roleList
		for i in numMafia:
			roleList.append("mafia")

		#append "villager" role into roleList
		for i in villagerCount:
			roleList.append("villager")

		#shuffle roleList
		shuffle(roleList)

		#assign list
		for i in range(playerCount):
			self.playerList[i].role = roleList[i]

	def alivePlayers(self):
		alivePlayersList = []

		#find alive players
		for player in self.playerList:
			if player.isAlive == True:
				#append into list
				alivePlayersList.append(player)

		return alivePlayersList



	def toJSON(self):

		infoDict = {"_type": "Room", "playerList": [player.toJSON() for player in self.playerList], \
		"roomName": self.roomName, "maxPlayers": self.maxPlayers, "owner": self.owner.toJSON(), \
		"password":self.password, "gameStarted": self.gameStarted}

		return infoDict

	def toSimpleJSON(self):

		infoDict = {"_type":"SimpleRoom", "currentNumPlayers": len(self.playerList), "roomName": self.roomName,\
		 "maxPlayers": self.maxPlayers, "owner":self.owner.name, "password": self.password, "roomTag": self.roomTag,\
		 "gameStarted": self.gameStarted}

		return infoDict
