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
    func requestWasReceived(fromPeerID: MCPeerID, callback: (Bool) -> Void)
//    func connectedWithPlayer(withPlayer: Player)
    func disconnectedFromPlayer(fromPlayer: Player)
}

extension HostManagerDelegate {
    func disconnectedFromPlayer(fromPlayer: Player) {
        // Intentionally left blank
    }
}

class HostManager: NSObject, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate {
    
    var hostDelegate: HostManagerDelegate?
    
    var session: MCSession!
    
    var foundPlayers: [Player]!
    
    private var advertiser: MCNearbyServiceAdvertiser!
    
    var thisPlayer: Player!
    
    var room: Room!
    
    static let shared: HostManager = HostManager()
    
    func convertPeerIDToString(peerID: MCPeerID) -> String {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: peerID)
        let encodedString = String(data: encodedData, encoding: .utf8)
        
        return encodedString!
    }
    
    func startRoom(player: Player, roomName: String, maxPeople: Int, password: String) {
        // Initialize values, setup advertiser, etc.
        
        //initialize other variables
        
        self.session = MCSession(peer: player.getPeerID())
        self.room = Room(roomName: roomName, owner: player, maxPlayers: maxPeople, password: password)
        
        // initialize advertiser
        var currentPlayerString = ""
        var currentPlayerIDString = ""
        for player in room.currentPlayers {
            currentPlayerString += "\(player.getName()),"
            currentPlayerIDString += "\(convertPeerIDToString(peerID: player.getPeerID())),"
        }
        currentPlayerString = currentPlayerString.substring(to: currentPlayerString.index(before: currentPlayerString.endIndex))
        currentPlayerIDString = currentPlayerIDString.substring(to: currentPlayerIDString.index(before: currentPlayerIDString.endIndex))
        
        let infoDict : [String: String] = ["roomName":room.roomName, "owner":room.owner.getName(), "maxPlayers":String(room.maxPlayers), "password": password, "currentPlayers": currentPlayerString, "currentPlayersID": currentPlayerIDString]
        advertiser = MCNearbyServiceAdvertiser(peer: player.getPeerID(), discoveryInfo: infoDict, serviceType: "mafia-game")
        advertiser.delegate = self
        
        
        advertiser.startAdvertisingPeer()
        
        

    }
    
    func endRoom() {
        
        // Cleanup state, disconnect, etc
    }
    
    var isRoomAvailable: Bool {
        get {
            if session.connectedPeers.count > 0 {
                return true
            }
            else {
                return false
            }
            
        }
    }
    
    private override init() {
        // Implemented for access control
        super.init()
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
    
    
    
    
    
    
    // MCSessionDelegate methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            
//            if let player = getPlayerFromPeerID(peerID: peerID){
//                hostDelegate?.connectedWithPlayer(withPlayer: player)
//            }
            
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

        hostDelegate?.requestWasReceived(fromPeerID:peerID, callback: { (shouldConnect: Bool) -> Void in
            if shouldConnect {
                invitationHandler(true, session)
            }
            else {
                invitationHandler(false, nil)
            }
        })
        
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print(error.localizedDescription)
    }
    
    
}
