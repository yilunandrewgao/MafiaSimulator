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
    
    var roomName: String
    var owner: Player
    var maxPlayers : Int
    var currentPlayers : [Player]
    
    
    init (roomName: String, owner: Player, maxPlayers: Int) {
        self.roomName = roomName
        self.owner = owner
        self.maxPlayers = maxPlayers
        self.currentPlayers = [owner]
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
    
    
}
