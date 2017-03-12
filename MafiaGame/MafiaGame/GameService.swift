//
//  GameService.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/8/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class GameService {
    
    public var thisPlayer: Player!
    public var roomList: [SimpleRoom]!
    public var inRoom: Room?
    public static var shared: GameService! = GameService()
    public var loggedIn: Bool = false
    
    private init() {
        //implemented for access control
    }
    
    func startGameService(thisPlayer:Player, roomList:[SimpleRoom]) {
        self.thisPlayer = thisPlayer
        self.roomList = roomList
    }
    

    func joinRoom(room:Room){
        self.inRoom = room
    }
}
