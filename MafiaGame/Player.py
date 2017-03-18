import json

class Player:

	name = None
	sid = None

	
	isAlive = True
	voteFor = None 

	#future implementation
	role = None
	avatar = None

	def __init__(self, name, sid):
		self.name = name
		self.sid = sid
		

	#alternative init from dictionary
	@classmethod
	def fromDict(cls, playerDict):
		name = playerDict["name"]
		sid = playerDict["sid"]
		

		return cls(name, sid)
	
	def __repr__(self):
		returnString = "("+self.name+", "+self.sid+")"
		return returnString

	def toJSON(self):
		infoDict = {"_type": "Player","name": self.name, "sid": self.sid, "isAlive": self.isAlive, role": self.role}

		return infoDict

	def joinRoom(room):
		inRoom = room
