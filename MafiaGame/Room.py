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

	def countVotes(self):
		#count all current votes

		#create an empty dictionary {"sid":votes}
		votes = {}
		#fill votes dictionary
		for player in self.playerList:
			votes[player.sid] = 0

		#count votes
		for player in self.playerList:
			votes[player.sid] = 0
			#check if player voted or not
			if player.voteFor != None:
				#increment the votedFor player's votes
				votes[player.voteFor] += 1

		#return the current vote dictionary
		return votes 

	

	def killPlayer(self, playerToKillSid):
		for player in self.playerList:
			if player.sid == playerToKill:
				if player.isAlive:
					player.isAlive = False
					print("player chosen to be killed ", player.name)
					return True
				else:
					return False
			else:
				print("playerToKill is not in room")
				return False

	def assignRoles(self):
		playerCount = len(self.playerList)
		numMafia = int(math.floor(math.sqrt(playerCount)))
		villagerCount = playerCount-numMafia

		roleList = []

		#append "mafia" role into roleList
		for i in range(numMafia):
			roleList.append("mafia")

		#append "villager" role into roleList
		for i in range(villagerCount):
			roleList.append("villager")

		#shuffle roleList
		shuffle(roleList)

		#assign list
		for i in range(playerCount):
			self.playerList[i].role = roleList[i]
			self.playerList[i].isAlive = True

	def alivePlayers(self):
		alivePlayersList = []

		#find alive players
		for player in self.playerList:
			if player.isAlive == True:
				#append into list
				alivePlayersList.append(player)

		return alivePlayersList

	def whoWon(self):
		#find alive players
		alivePlayersList = self.alivePlayersList()
		#variable to keep track of alive mafia
		mafiaCount = 0
		#variable to keep track of alive villagers
		villagerCount = 0

		for player in alivePlayersList:
			if player.role == "mafia":
				mafiaCount += 1
			else:
				villagerCount += 1

		#if mafiaCount is the same as villager, mafia wins
		if mafiaCount == villagerCount:
			return "mafia"
		#if no mafia are left
		elif mafiaCount == 0:
			return "villagers"
		#else game still continues, return None for no winners	
		else:
			return None

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
