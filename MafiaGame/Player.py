import json

class Player:

	name = None
	sid = None

	#future implementation
	role = None
	avatar = None

	def __init__(self, name, sid):
		self.name = name
		self.sid = sid

	def toJSON(self):
		infoDict = {"_type": "Player","name": self.name, "sid": self.sid}

		return infoDict
