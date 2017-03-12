from flask import Flask, render_template, request
from flask_socketio import SocketIO, send, emit
from Player import Player
from Room import Room
import MafiaEncoder
import json

room1 = Room("room1","password1",5,Player("Alice",1))

room2 = Room("room2","password2",5,Player("Bob",2))

room1.addPlayer(Player("Carol",3))

roomList = [room1,room2]

# print(json.dumps(room1,cls = MafiaEncoder.MafiaEncoder))

# print(json.dumps(roomList, cls = MafiaEncoder.MafiaEncoder))

# print(json.loads(json.dumps(roomList, cls = MafiaEncoder.MafiaEncoder))[0])

print([room.toJSON() for room in roomList])

