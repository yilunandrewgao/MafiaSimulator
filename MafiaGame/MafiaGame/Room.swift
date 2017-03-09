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
    let password: String
    let maxPlayers : Int
    let owner: Player
    
    
    
    
    init() {
        self.roomName = roomName
        self.owner = owner
        self.maxPlayers = maxPlayers
        self.currentPlayers = [owner]
        self.password = password
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
