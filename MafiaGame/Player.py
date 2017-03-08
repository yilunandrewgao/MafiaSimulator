import json

class Player:

	name = None
	sid = None

	#future implementation
	role = None
	avatar = None
	inRoom = None

	def __init__(self, name, sid):
		self.name = name
		self.sid = sid

	def joinRoom(Room):
		self.inRoom = Room

	def toJSON():
		infoDict = {"name": self.name, "sid": self.sid}

		return json.dumps(infoDict)
