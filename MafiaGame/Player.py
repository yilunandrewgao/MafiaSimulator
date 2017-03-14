import json

class Player:

	name = None
	sid = None
	isAlive = None

	#future implementation
	role = None
	avatar = None

	def __init__(self, name, sid, isAlive):
		self.name = name
		self.sid = sid
		self.isAlive = isAlive

	#alternative init from dictionary
	@classmethod
	def fromDict(cls, playerDict):
		name = playerDict["name"]
		sid = playerDict["sid"]
		isAlive = playerDict["isAlive"]

		return cls(name, sid, isAlive)
	
	def __repr__(self):
		returnString = "("+self.name+", "+self.sid+")"
		return returnString

	def toJSON(self):
		infoDict = {"_type": "Player","name": self.name, "sid": self.sid, "isAlive": self.isAlive}

		return infoDict

	def joinRoom(room):
		inRoom = room
