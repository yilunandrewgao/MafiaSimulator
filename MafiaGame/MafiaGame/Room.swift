//
//  Room.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/27/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit


class Room {
    
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
    }
    
//    func addPlayer(player: Player) -> Bool{
//        if currentPlayers.count >= maxPlayers {
//            return false
//        }
//        else {
//            currentPlayers.append(player)
//            return true
//        }
//    }
//    
//    func dropPlayer(peerID: MCPeerID) {
//        currentPlayers = currentPlayers.filter {$0.getPeerID() != peerID}
//        
//    }
//    
    
    
}
