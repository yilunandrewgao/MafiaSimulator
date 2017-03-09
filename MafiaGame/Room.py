import json
from Player import Player
import MafiaEncoder

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

		if len(self.playerList) < self.maxPlayers:
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

		infoDict = {"playerList": self.playerList, "roomName": self.roomName, \
		"maxPlayers": self.maxPlayers, "owner": self.owner}

		return infoDict

	def toSimpleJSON(self):

		infoDict = {"currentNumPlayers": len(self.playerList), \
		"roomName": self.roomName, "maxPlayers": self.maxPlayers, "owner":self.owner}

		return infoDict


