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
    
    var hostDelegate: HostManagerDelegate?
    
    var sessionsList: [MCSession]
    
    var playersInGame: [Player]
    
    var foundPlayers: [Player]
    
    var advertiser: MCNearbyServiceAdvertiser
    
    var thisPlayer: Player
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    static var shared: HostManager?
    
    private init(player: Player) {
        super.init()

        
        // initialize advertiser
        
        advertiser = MCNearbyServiceAdvertiser(peer: player.getPeerID(), discoveryInfo: nil, serviceType: "mafia-game")
        advertiser.delegate = self
        
        //initialize other variables

        sessionsList = []
        playersInGame = []
        foundPlayers = []
        thisPlayer = player
    
    }
    
    
    // initialize hostManager
    static func initHostManager(player:Player) {
        shared = HostManager(player: player)
    }
    
    
}
