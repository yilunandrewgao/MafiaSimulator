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
    func foundRoom()
    
    func lostRoom()

}

class ClientManager: NSObject, MCSessionDelegate, MCNearbyServiceBrowserDelegate {
    
    var clientDelegate: ClientManagerDelegate?
    
    var session: MCSession!
    
    var thisPlayer: Player!
    
    var browser: MCNearbyServiceBrowser?
    
    var foundRooms : [Room]!
    
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
        self.foundRooms = []
        
        // initalize browser
        self.browser = MCNearbyServiceBrowser(peer: player.getPeerID(), serviceType: "mafia-game")
        browser?.delegate = self
        
        browser?.startBrowsingForPeers()
    }
    
    private func convertStringToPeerID(encodedString : String) -> MCPeerID {
        let encodedData = Data(base64Encoded: encodedString)
        let peerID = NSKeyedUnarchiver.unarchiveObject(with: encodedData!) as! MCPeerID
        
        return peerID
    }

    
    // MSNearbyServiceBrowserDelegate methods
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        let hostPlayer = Player(name: info!["owner"]!, peerID: peerID)
        let newRoom = Room(roomName: info!["roomName"]!, owner: hostPlayer, maxPlayers: Int(info!["maxPlayers"]!)!, password: info!["password"]!)
        
        // add players to room
        let playerList = info!["currentPlayers"]!.characters.split {$0 == ","}.map(String.init)
        for index in 0..<playerList.count {
            let success = newRoom.addPlayer(player: Player(name: playerList[index]))
            if !success {
                print("failed to add player")
            }
        }
        
        
        foundRooms.append(newRoom)
        
        clientDelegate?.foundRoom()
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        
        foundRooms = foundRooms.filter { $0.owner.getPeerID() != peerID }
        
        clientDelegate?.lostRoom()
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
