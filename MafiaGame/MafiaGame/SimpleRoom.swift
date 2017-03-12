//
//  SimpleRoom.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/10/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class SimpleRoom {
    
    private(set) var numPlayers: Int
    private(set) var roomName: String
    private(set) var password: String
    private(set) var maxPlayers : Int
    private(set) var owner: String
    let roomTag: String
    
    public var description : String {
        return "\(self.roomName) by \(self.owner): \(self.numPlayers)/\(self.maxPlayers)"
    }
    
    init(numPlayers: Int, roomName: String, password: String, maxPlayers: Int, owner: String, roomTag: String) {
        self.numPlayers = numPlayers
        self.roomName = roomName
        self.password = password
        self.maxPlayers = maxPlayers
        self.owner = owner
        self.roomTag = roomTag
    }
    
}
