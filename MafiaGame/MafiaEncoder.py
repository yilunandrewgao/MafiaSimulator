import json
import Room
from Player import Player

class MafiaEncoder(json.JSONEncoder):

	def default(self,obj):
		if isinstance(obj, Player):
			return obj.toJSON()
		elif isinstance(obj, Room.Room):
			return obj.toJSON()

		else:
			return json.JSONEncoder.default(self, obj)

class SimpleMafiaEncoder(json.JSONEncoder):

	def default(self,obj):

		if isinstance(obj, Player):
			return obj.toJSON()
		elif isinstance(obj, Room.Room):
			return obj.toSimpleJSON()
		else:
			return json.JSONEncoder.default(self, obj)