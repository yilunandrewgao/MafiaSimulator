//
//  Room.swift
//  MafiaGame
//
//  Created by Yilun Gao on 2/27/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit



class Room: CustomStringConvertible {
    
    private(set) var playerList: [Player]
    public var alivePlayerList: [Player]?
    public var voteCountDic: [String:Int]?
    private(set) var roomName: String
    private(set) var password: String
    private(set) var maxPlayers : Int
    private(set) var owner: Player
    public var gameStarted: Bool
    public var chatHistory: [[String:String]]?
    
    //killed player's sid
    public var killedPlayerSid: String?
    public var killedPlayer: String?
    
    //which side won
    public var whoWon: String?
    
    
    public var description : String {
        return "\(self.roomName) by \(String(describing: self.owner)): \(self.playerList.count)/\(self.maxPlayers)"
    }
    
    public func toDict() -> [String:Any] {
        let roomDict = ["roomName": self.roomName, "password": self.password, "maxPlayers": self.maxPlayers, "owner": self.owner.toDict()] as [String : Any]
        return roomDict
    }
    
    init(playerList: [Player], roomName: String, password: String, maxPlayers: Int, owner: Player) {
        self.playerList = playerList
        self.roomName = roomName
        self.password = password
        self.maxPlayers = maxPlayers
        self.owner = owner
        self.gameStarted = false

    }
    
    public func resetChat() {
        chatHistory = []
    }
    
    
    
}
