//
//  Player.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//


import Foundation
import MultipeerConnectivity

class Player {
    
    private var name: String
    private var peerID: MCPeerID
    private var hostOrNot: Bool = false
    
    init(name: String) {
        self.name = name
        self.peerID = MCPeerID(displayName: name)
    }
    
    init(name: String, peerID: MCPeerID) {
        self.name = name
        self.peerID = peerID
    }
    
    
    // basic getters and setters
    func getName() -> String {
        return self.name
    }
    
    func setname(name: String) {
        self.name = name
    }
    
    func getPeerID() -> MCPeerID {
        return self.peerID
    }
    
    func setPeerID(peerID: MCPeerID) {
        self.peerID = peerID
    }
    
    func getHostORNot() -> Bool {
        return self.hostOrNot
    }
    
    func setHostOrNot(isHost: Bool) {
        self.hostOrNot = isHost
    }
    
}
