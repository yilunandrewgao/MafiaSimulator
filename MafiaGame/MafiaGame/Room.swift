//
//  Room.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/27/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Room {
    
    let roomName: String
    let owner: Player
    let maxPlayers : Int
    var currentPlayers : [Player]
    let password: String
    
    
    init (roomName: String, owner: Player, maxPlayers: Int, password: String) {
        self.roomName = roomName
        self.owner = owner
        self.maxPlayers = maxPlayers
        self.currentPlayers = [owner]
        self.password = password
    }
    
    func addPlayer(player: Player) -> Bool{
        if currentPlayers.count >= maxPlayers {
            return false
        }
        else {
            currentPlayers.append(player)
            return true
        }
    }
    
    func dropPlayer(peerID: MCPeerID) {
        currentPlayers = currentPlayers.filter {$0.getPeerID() != peerID}
        
    }
    
    
    
}
