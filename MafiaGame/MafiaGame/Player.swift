//
//  Player.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import Foundation
//import MultipeerConnectivity

class Player: CustomStringConvertible {
    
    private(set) var name: String
    private(set) var sid: String
    private(set) var isAlive: Bool
    
    public var description: String {
        return "(\(self.name), \(self.sid), \(self.isAlive))"
    }
    
    public func toDict() -> [String:Any] {
        let playerDict = ["name": self.name, "sid": self.sid, "alive": self.isAlive] as [String : Any]
        
        return playerDict
    }
    
    init(name: String, sid: String, isAlive: Bool) {
        self.name = name
        self.sid = sid
        self.isAlive = isAlive
    }
    
    
    
}
