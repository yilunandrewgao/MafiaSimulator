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
    
    var advertiser: MCNearbyServiceAdvertiser!
    
    var thisPlayer: Player
    
    var invitationHandler: ((Bool, MCSession?)->Void)!
    
    static var shared: HostManager?
    
    private init(player: Player) {
        
        //initialize other variables
        
        sessionsList = []
        playersInGame = []
        foundPlayers = []
        thisPlayer = player
        
        
        super.init()
        
        
        
        // initialize advertiser
        
        advertiser = MCNearbyServiceAdvertiser(peer: player.getPeerID(), discoveryInfo: nil, serviceType: "mafia-game")
        advertiser.delegate = self
        
        
    
    }
    
    // function to get player from peerID
    func getPlayerFromPeerID(peerID: MCPeerID) -> Player? {
        for player in foundPlayers {
            if player.getPeerID() == peerID {
                return player
            }
        }
        return nil
    }
    
    
    
    
    
    // initialize hostManager
    static func initHostManager(player:Player) {
        shared = HostManager(player: player)
    }
    
    
    
    
    
    
    // MCSessionDelegate methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            
            if let player = getPlayerFromPeerID(peerID: peerID){
                hostDelegate?.connectedWithPlayer(withPlayer: player)
            }
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    
    // stuff we don't need
    
    func session(_ session: MCSession,
                 didReceive data: Data,
                 fromPeer peerID: MCPeerID){
        
    }
    
    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress){
        
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL,
                 withError error: Error?){
        
    }
    
    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID){
        
    }
    
    
    // Advertiser delegate methods
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping ((Bool, MCSession?) -> Void)) {
        self.invitationHandler = invitationHandler
        if let player = getPlayerFromPeerID(peerID: peerID) {
           hostDelegate?.requestWasReceived(fromPlayer: player)
        }
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    
}
