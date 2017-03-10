//
//  JsonDecodeEncode.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/7/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit


enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Player {
    
    convenience init(json: [String:Any]) throws {
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let sid = json["sid"] as? Int else {
            throw SerializationError.missing("sid")
        }
        
        self.init(name:name, sid:sid)
    }
}


extension Room{
    
    convenience init(json: [String:Any]) throws {
        guard let playerListJSON = json["playerList"] as? [[String:Any]] else {
            throw SerializationError.missing("playerList")
        }
        var playerList: [Player] = []
        for playerJSON in playerListJSON {
            let player = try Player(json: playerJSON)
            playerList.append(player)
        }
        guard let roomName = json["roomName"] as? String else{
            throw SerializationError.missing("roomName")
        }
        guard let password = json["password"] as? String else{
            throw SerializationError.missing("password")
        }
        guard let maxPlayers = json["maxPlayers"] as? Int else {
            throw SerializationError.missing("maxPlayers")
        }
        guard let ownerJSON = json["owner"] as? [String:Any] else {
            throw SerializationError.missing("owner")
        }
        let owner = try Player(json: ownerJSON)
        
        self.init(playerList: playerList, roomName: roomName, password: password, maxPlayers: maxPlayers, owner:owner)
    }
    
  
}
