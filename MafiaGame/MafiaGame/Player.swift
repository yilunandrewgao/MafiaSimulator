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
    
    public var isAlive: Bool?
    public var role: String?
    //private(set) var voteFor: String?
    
    public var description: String {
        return "(\(self.name), \(self.sid), \(self.role))"
    }
    
    public func toDict() -> [String:Any] {
        let playerDict = ["name": self.name, "sid": self.sid, "role": self.role]
        
        return playerDict
    }
    
    init(name: String, sid: String) {
        self.name = name
        self.sid = sid
       
    }
    
    
    
}
