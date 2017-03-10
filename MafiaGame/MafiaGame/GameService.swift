//
//  GameService.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/8/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit

class GameService {
    
    private(set) var thisPlayer: Player!
    private(set) var roomList: [SimpleRoom]!
    private(set) var inRoom: Room?
    public var shared: GameService = GameService()
    
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
