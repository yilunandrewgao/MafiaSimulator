//
//  Room.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/27/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit


class Room {
    
<<<<<<< HEAD
    let playerList: [Player]
    let roomName: String
    let maxPlayers : Int
    let owner: Player
    
    //json object
    
    
    
    init() {
        ///////fake json object
        //fake dictionary
        var infoDict = ["playerList": [["name":"bob", "sid":"1"], ["name":"mike", "sid":"1"]], "roomName":"test", "password":"testPassword", "maxPlayer": 5, "owner": ["name": "bob", "sid" : "1"]]
        
        self.playerList = createPlayerList()
        self.roomName = roomName
        self.owner = owner
        self.maxPlayers = maxPlayers
=======
    private(set) var playerList: [Player]
    private(set) var roomName: String
    private(set) var password: String
    private(set) var maxPlayers : Int
    private(set) var owner: Player
    
    init(playerList: [Player], roomName: String, password: String, maxPlayers: Int, owner: Player) {
        self.playerList = playerList
        self.roomName = roomName
        self.password = password
        self.maxPlayers = maxPlayers
        self.owner = owner
>>>>>>> 142d4c60b62ded216dddf48f3ad3a15b97e9cec9
    }
    
    
}
