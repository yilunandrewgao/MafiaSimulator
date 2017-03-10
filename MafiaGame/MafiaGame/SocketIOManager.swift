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
    
    var socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://10.111.193.140:7777")!, config: [.log(true), .forceWebsockets(true), .connectParams(["name": GameService.shared.thisPlayer.name])])
    
    
    func establishConnection(){
        
        
        socket.on("SetPlayer") {(dataArray,ack)->Void in
            let playerData = dataArray[0] as! Data
            let json = try? JSONSerialization.jsonObject(with: playerData, options: []) as! [String:Any]
            let roomListData = dataArray[1] as! Data
            let roomListJSON = try? JSONSerialization.jsonObject(with: roomListData, options: []) as! [[String:String]]
            
            var simpleRoomList:[SimpleRoom] = []
            for roomJSON in roomListJSON! {
                try? simpleRoomList.append(SimpleRoom(json: roomJSON))
            }
        
            GameService.shared.startGameService(thisPlayer:  try! Player(playerInfo: json!), roomList: simpleRoomList)
        }
        
        socket.connect()
        
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    
//    func userExitRoom(completionHandler: @escaping (_ userList: [[String: AnyObject]]?) -> Void) {
//        socket.emit("UserExitRoom")
//        socket.on("userList") { ( dataArray, ack) -> Void in
//            completionHandler(dataArray[0] as? [[String: AnyObject]])
//        }
//        
//        
//        
//    }
//    
//    func userJoinRoom(completionHandler: () -> Void) {
//        socket.emit("UserJoinRoom")
//        
//        socket.on(
//        sompletionHandler()
//    }
//    
    
}
