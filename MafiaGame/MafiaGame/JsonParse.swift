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
    
    convenience init(playerInfo : [String:Any]) throws {
       
        
        guard let name = playerInfo["name"] as? String else {
            throw SerializationError.missing("name")
        }
        guard let sid = playerInfo["sid"] as? String else {
            throw SerializationError.missing("sid")
        }
        
        guard let isAlive = playerInfo["isAlive"] as? Bool else {
            throw SerializationError.missing("alive status")
        }
        
        self.init(name:name, sid:sid, isAlive:isAlive)
    }
}


extension Room{
    
    convenience init(json: [String:Any]) throws {
        
        
        //player list
        guard let playerListJSON = json["playerList"] as? [[String:Any]] else {
            throw SerializationError.missing("playerList")
        }
        var playerList: [Player] = []
        for playerJSON in playerListJSON {
            let player = try Player(playerInfo: playerJSON)
            playerList.append(player)
        }
        
        guard let alivePlayerListJSON = json["alivePlayerList"] as? [[String:Any]] else{
            throw SerializationError.missing("alivePlayerList")
        }
        
        var alivePlayerList: [Player] = []
        for alivePlayerJSON in alivePlayerListJSON {
            let alivePlayer = try Player(playerInfo: alivePlayerJSON)
            alivePlayerList.append(alivePlayer)
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
        
        let owner = try Player(playerInfo: ownerJSON)
        
        self.init(playerList: playerList, alivePlayerList: alivePlayerList, roomName: roomName, password: password, maxPlayers: maxPlayers, owner:owner)
    }
}
    
extension SimpleRoom{
    convenience init(json: [String:Any]) throws {
            
            guard let currentNumPlayers = json["currentNumPlayers"] as? Int else{
                throw SerializationError.missing("currentNumPlayers")
            }
            
            guard let roomName = json["roomName"] as? String else{
                throw SerializationError.missing("roomName")
            }
            
            guard let maxPlayers = json["maxPlayers"] as? Int else {
                throw SerializationError.missing("maxPlayers")
            }
            
            //owner
            guard let ownerName = json["owner"] as? String else{
                throw SerializationError.missing("owner")
            }
            
            guard let password = json["password"] as? String else{
                throw SerializationError.missing("password")
            }
        
            guard let roomTag = json["roomTag"] as? String else {
                throw SerializationError.missing("roomTag")
            }
        
        self.init(numPlayers: currentNumPlayers, roomName: roomName, password: password, maxPlayers: maxPlayers, owner: ownerName, roomTag: roomTag)
        }
}
  

