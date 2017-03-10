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
        guard let sid = playerInfo["sid"] as? Int else {
            throw SerializationError.missing("sid")
        }
        
        self.init(name:name, sid:sid)
    }
}


extension Room{
    
    convenience init(dataJSON: Data) throws {
        let json = try? JSONSerialization.jsonObject(with: dataJSON, options: [])
        
        guard let roomDict = json as? [String:Any] else{
            throw SerializationError.missing("JsonObject")
        }
        
        //player list
        guard let playerListJSON = roomDict["playerList"] as? [[String:Any]] else {
            throw SerializationError.missing("playerList")
        }
        var playerList: [Player] = []
        for playerJSON in playerListJSON {
            let player = try Player(json: playerJSON)
            playerList.append(player)
        }
        
        
        guard let roomName = roomDict["roomName"] as? String else{
            throw SerializationError.missing("roomName")
        }
        guard let password = roomDict["password"] as? String else{
            throw SerializationError.missing("password")
        }
        guard let maxPlayers = roomDict["maxPlayers"] as? Int else {
            throw SerializationError.missing("maxPlayers")
        }
        guard let ownerJSON = roomDict["owner"] as? [String:Any] else {
            throw SerializationError.missing("owner")
        }
        
        let owner = try Player(playerInfo: ownerJSON)
        
        self.init(playerList: playerList, roomName: roomName, password: password, maxPlayers: maxPlayers, owner:owner)
    }
}
    
extension SimpleRoom{
        convenience init(dataJSON: Data){
            let json = try? JSONSerialization.jsonObject(with: dataJSON, options: [])
            
            guard let simpleRoomDict = json as? [String:Any] else{
                throw SerializationError.missing("simpleRoom")
            }
            
            guard let currentNumPlayers = simpleRoomDic["currentNumPlayers"] as? Int else{
                throw SerializationError.missing("currentNumPlayers")
            }
            
            guard let roomName = simpleRoomDict["roomName"] as? String else{
                throw SerializationError.missing("roomName")
            }
            
            guard let maxPlayers = simpleRoomDict["maxPlayers"] as? Int else {
                throw SerializationError.missing("maxPlayers")
            }
            
            //owner
            guard let ownerJson = simpleRoomDict["owner"] as? String else{
                throw Serialization.missing("owner")
            }
            let owner = try Player(playerInfo: ownerJson)
            
            guard let password = simpleRoomDict["password"] as? String else{
                throw SerializationError.missing("password")
            }
            
            self.init(currentNumPlayers: currentNumPlayers, roomName: roomName, maxPlayers: maxPlayers, owner: owner, password: password)
        }
}
  

