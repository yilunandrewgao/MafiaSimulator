//
//  Player.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import Foundation
//import MultipeerConnectivity

class Player {
    
    private(set) var name: String
    private(set) var sid: Int
    
    
    init(name: String, sid: Int) {
        self.name = name
        self.sid = sid
    }
    
}
