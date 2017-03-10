//
//  SocketIOManager.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/7/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
class SocketIOManager: NSObject {
    static let shared = SocketIOManager()
    
    private override init(){
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://10.111.194.65:7777")!)
    
    func establishConnection(){
        socket.connect()
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    
    func userExitRoom(completionHandler: () -> Void) {
        socket.emit("UserExitRoom")
        socket.on("roomListUpdate") { (dataAray, ack) -> Void in
            completionHandler(_ : dataArray[0] as? [[String: AnyObject]])
        completionHandler()
    }
    
    func userJoinRoom(completionHandler: () -> Void) {
        socket.emit("UserJoinRoom")
        
        sompletionHandler()
    }
    
    
}
