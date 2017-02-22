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

<<<<<<< HEAD
class HostManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var hostDelegate: HostManagerDelegate
=======

class HostManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var hostDelegate: HostManagerDelegate?
>>>>>>> f682f8e47f8d0ae1f587d9e0f12d8188f96192be
    
    var sessionsList: [MCSession]
    
    var playersInGame: [Player]
    
    var foundPlayers: [Player]
    
    var advertiser: MCNearbyServiceAdvertiser
    
    var thisPlayer: Player
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
<<<<<<< HEAD
    static let shared: HostManager!
=======
    static var shared: HostManager?
>>>>>>> f682f8e47f8d0ae1f587d9e0f12d8188f96192be
    
    private init(player: Player) {
        super.init()
        
<<<<<<< HEAD
        advertiser = MCNearbyServiceAdvertiser(peer: player.getPeerID(), discoveryInfo: nil, serviceType: "mafia-game")
        advertiser.delegate = self
=======
        
        // initialize advertiser
        
        advertiser = MCNearbyServiceAdvertiser(peer: player.getPeerID(), discoveryInfo: nil, serviceType: "mafia-game")
        advertiser.delegate = self
        
        //initialize other variables

        sessionsList = []
        playersInGame = []
        foundPlayers = []
        thisPlayer = player
    
>>>>>>> f682f8e47f8d0ae1f587d9e0f12d8188f96192be
    }
    
    
    // initialize hostManager
    static func initHostManager(player:Player) {
        shared = HostManager(player: player)
    }
    
    
}
<<<<<<< HEAD
=======

>>>>>>> f682f8e47f8d0ae1f587d9e0f12d8188f96192be
