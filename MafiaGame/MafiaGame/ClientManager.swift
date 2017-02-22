//
//  ClientManager.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/21/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
import MultipeerConnectivity

protocol ClientManagerDelegate {
    func foundHost()
    
    func lostHost()

}

class ClientManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    
    var clientDelegate: ClientManagerDelegate?
    
    var session: MCSession!
    
    var thisPlayer: Player
    
    var browser: MCNearbyServiceBrowser?
    
    var foundHosts: [Player]
    
    // Singleton
    static private(set) var shared: ClientManager!
    
    static func initClientManager(player: Player) {
        shared = ClientManager(player: player)
    }

    //init
    private init(player: Player) {
        
        //initialize other variables
        
        foundHosts = []
        thisPlayer = player
       
        
        super.init()
        
        
        // initialize browser
        
        browser = MCNearbyServiceBrowser(peer: peer, serviceType: "mafia-game")
        browser!.delegate = self
        
        
        
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
    

    
    // MSNearbyServiceBrowserDelegate methods
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if let foundPlayer = getPlayerFromPeerID(peerID: peerID) {
            foundHosts.append(foundPlayer)
        }
        
        
        clientDelegate?.foundHost()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        
        foundHosts = foundHosts.filter { $0.getPeerID() != peerID }
        
        clientDelegate?.lostHost()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        print(error.localizedDescription)
    }
    

    
    // MCSessionDelegate methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
           
            
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
    


}
