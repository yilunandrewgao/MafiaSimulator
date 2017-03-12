//
//  SocketIOManager.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/7/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import UIKit
class SocketIOManager: NSObject {
    static let shared : SocketIOManager = SocketIOManager()
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://10.110.192.239:7777")!, config: [.log(false), .forceWebsockets(true), .reconnects(false)])


    private override init(){
        super.init()
        initHandlers()
    }
    
    
    func initHandlers() {
        socket.on("SetPlayer") { (dataArray, ack) in
            
            let playerJSON = dataArray[0] as! [String:Any]
            let roomListJSON = dataArray[1] as! [[String:Any]]
            
            var simpleRoomList:[SimpleRoom] = []
            for roomJSON in roomListJSON {
                try? simpleRoomList.append(SimpleRoom(json: roomJSON))
            }
            
            GameService.shared.startGameService(thisPlayer: try! Player(playerInfo: playerJSON), roomList: simpleRoomList)

        }
        
        socket.on("connect") { data, ack in
            self.socket.emit("setPlayer", GameService.shared.thisPlayer.name)
        }
        
//        socket.on("roomUpdate") { data, ack in
//            let roomJSON = data[0] as! [String:Any]
//            
//            GameService.shared.inRoom = try! Room(json: roomJSON)
//        }
//        
        
        socket.on("roomListUpdate") { data, ack in
            let roomListJSON = data[0] as! [[String:Any]]
            
            var simpleRoomList:[SimpleRoom] = []
            for roomJSON in roomListJSON {
                try? simpleRoomList.append(SimpleRoom(json: roomJSON))
            }
            
            GameService.shared.roomList = simpleRoomList
            
        }
        

    }
    
    
    func establishConnection(){
        
        socket.connect()
        
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    
    func sendCreateRoomEvent(newRoom: Room, completionHandler: @escaping (_ roomJSON: [String: Any]) -> Void) {
        socket.emit("createRoom", newRoom.toDict())
        
        socket.on("roomUpdate") { (data, ack) -> Void in
            completionHandler(data[0] as! [String:Any])
        }
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
