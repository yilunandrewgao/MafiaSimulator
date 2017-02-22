//
//  File.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/19/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol HostManagerDelegate {
    func foundPlayer()
    func lostPlayer()
    func requestWasReceived(fromPlayer: Player)
    func connectedWithPlayer(withPlayer: Player)
    func disconnectedFromPlayer(fromPlayer: Player)
}

class HostManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var hostDelegate: HostManagerDelegate
    
    var sessionsList: [MCSession]
    
    var playersInGame: [Player]
    
    var foundPlayers: [Player]
    
    var advertiser: MCNearbyServiceAdvertiser
    
    var thisPlayer: Player
}