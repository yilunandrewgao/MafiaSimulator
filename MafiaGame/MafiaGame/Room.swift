//
//  Room.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/27/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit


class Room {
    
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
    }
    
    
}
