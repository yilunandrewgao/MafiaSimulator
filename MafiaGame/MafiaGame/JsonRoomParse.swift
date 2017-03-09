//
//  JsonDecodeEncode.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/7/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

extension Room{
//    var playerListParse = [[String:String]]()
//    var roomNameParse: String
//    var roomPasswordParse: String
//    var maxPlayersParse: Int
//    var ownerInfoParse = [String:String]()
    
    var playerList : [Player]
    
    func playerListParse(json: JSON){
        guard let players = json["playerList"] as? [[String:String]] else {
            throw JsonError.checkError(noPlayerList)
        }
        
        return players
    }
    
    func roomNameParse(json: JSON){
        guard let roomName = json["roomName"] as? String else{
            throw JsonError.checkError(noRoomName)
            
        }
        
        return roomName
    }
    
    func parse(json: JSON) throws{
        
        guard let roomName = json["roomName"] as? String else{
            throw JsonError.checkError(noRoomName)
            
        }
                }
        guard let maxPlayers = json["maxPlayers"] as? Int else{
            throw JsonError.checkError(noMaxPlayer)
            
        }
        guard let ownerInfo = json["owner"] as? [String:String] else{
            throw JsonError.checkError(noOwner)
            
        }
        
       
        self.roomNameParse = roomName
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
