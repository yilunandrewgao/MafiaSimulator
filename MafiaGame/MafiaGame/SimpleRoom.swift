//
//  SimpleRoom.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/10/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class SimpleRoom {
    private(set) var currentNumPlayers: Int
    private(set) var roomName: String
    private(set) var maxPlayers : Int
    private(set) var owner: Player
    private(set) var password: String
    
    init(currentNumPlayers: Int, roomName: String, maxPlayers: Int, owner: Player, password: String) {
        self.currentNumPlayers = currentNumPlayers
        self.roomName = roomName
        self.maxPlayers = maxPlayers
        self.owner = owner
        self.password = password
    }
    
}
