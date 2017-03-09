//
//  JsonErrors.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/8/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

enum JsonError: Error {
    case unknownError
    
    case noPlayerList
    //mising player elements
    case noPlayerName
    case noPlayerSid
    
    case noRoomName
    case noPasword
    case noMaxPlayer
    
    case noOwner
    //missing owner elements
    case noOwnerName
    case noOwnerSid
    
    
    func checkError(for errorType: JsonError = .unknownError) -> String {
        
        switch(errorType){
        case .noPlayerList:
            print("no player list")
        case .noPlayerName:
            print("no player name")
        case .noPlayerSid:
            print("no player sid")
        case .noRoomName:
            print("no room name")
        case .noPasword:
            print("room has no password")
        case .noMaxPlayer:
            print("no set max player")
        case .noOwner:
            print("room has no owner")
        case .noOwnerName:
            print("owner has no name")
        case .noOwnerSid:
            print("owner has no sid")
        default:
            print("error unkown")
        }
    }
}
