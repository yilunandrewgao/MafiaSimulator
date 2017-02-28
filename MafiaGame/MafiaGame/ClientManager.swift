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
    
    var thisPlayer: Player!
    
    var browser: MCNearbyServiceBrowser?
    
    var foundHosts: [(Player, [String : String]?)]!
    
    // Singleton
    static let shared: ClientManager = ClientManager()
    

    //init
    private override init() {
        // implemented for access control
        super.init()
    }
    
    func startBrowsing(player: Player) {
        // initialize variables
        self.thisPlayer = player
        self.foundHosts = []
        self.session = MCSession(peer: player.getPeerID())
        
        // initalize browser
        self.browser = MCNearbyServiceBrowser(peer: player.getPeerID(), serviceType: "mafia-game")
        browser?.delegate = self
        
        browser?.startBrowsingForPeers()
    }
    
    // function to get player from peerID
    func getPlayerFromPeerID(peerID: MCPeerID) -> Player? {
        for player in foundHosts.map({$0.0}) {
            if player.getPeerID() == peerID {
                return player
            }
        }
        return nil
    }
    

    
    // MSNearbyServiceBrowserDelegate methods
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        if let foundPlayer = getPlayerFromPeerID(peerID: peerID) {
            foundHosts.append((foundPlayer,info))
        }
        
        
        clientDelegate?.foundHost()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        
        foundHosts = foundHosts.filter { $0.0.getPeerID() != peerID }
        
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
