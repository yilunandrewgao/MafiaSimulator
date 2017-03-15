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
    private(set) var isAlive: Bool?
    
    private(set) var vote: Int?
    private(set) var role: String?
    
    public var description: String {
        return "(\(self.name), \(self.sid))"
    }
    
    public func toDict() -> [String:Any] {
        let playerDict = ["name": self.name, "sid": self.sid] 
        
        return playerDict
    }
    
    init(name: String, sid: String) {
        self.name = name
        self.sid = sid
       
    }
    
    
    
}
