//
//  JsonDecodeEncode.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/7/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class JsonRoomParse{
    var playerListParse = [[String:String]]()
    var roomNameParse: String
    var roomPasswordParse: String
    var maxPlayersParse: Int
    var ownerInfoParse = [String:String]()
    
    var playerList : [Player]
    
    public init(json: JSON) throws{
        guard let players = json["playerList"] as? [[String:String]] else {
            throw JsonError.checkError(noPlayerList)
        }
        guard let roomName = json["roomName"] as? String else{
            throw JsonError.checkError(noRoomName)
            
        }
        guard let roomPassword = json["password"] as? String else{
            throw JsonError.checkError(noPasword)
            
        }
        guard let maxPlayers = json["maxPlayers"] as? Int else{
            throw JsonError.checkError(noMaxPlayer)
            
        }
        guard let ownerInfo = json["owner"] as? [String:String] else{
            throw JsonError.checkError(noOwner)
            
        }
        
        self.playerListParse = players
        self.roomNameParse = roomName
        self.roomPasswordParse = roomPassword
        self.maxPlayersParse = maxPlayers
        self.ownerInfoParse = ownerInfo
        self.playerList = createPlayerList()
        
        
        
    }
    
    
    func createPlayerList() -> [Player]{
        var newPlayer : Player
        var newPlayerList : [Player]
        for player in playerListParse{
            newPlayer = Player.init(name: player["name"], sid: player["sid"])
            newPlayerList.append(newPlayer)
        }
        
        return newPlayerList
        
    }
  
}
