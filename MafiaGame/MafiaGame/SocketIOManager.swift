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
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.0.24:7777")!, config: [.log(false), .forceWebsockets(true), .reconnects(false)])


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
            NotificationCenter.default.post(name: .connectedToServerNotification, object: nil)
            self.socket.emit("setPlayer", GameService.shared.thisPlayer.name)
        }
        
        
        socket.on("roomListUpdate") { data, ack in
            let roomListJSON = data[0] as! [[String:Any]]
            
            var simpleRoomList:[SimpleRoom] = []
            for roomJSON in roomListJSON {
                try? simpleRoomList.append(SimpleRoom(json: roomJSON))
            }
            
            GameService.shared.roomList = simpleRoomList
            NotificationCenter.default.post(name: .updateRoomsTableNotification, object: nil)
            
        }
        
        socket.on("roomUpdate") { data, ack in
            let roomJSON = data[0] as! [String:Any]
            GameService.shared.inRoom = try! Room(json: roomJSON)
            NotificationCenter.default.post(name: .updateRoomNotification, object: nil)
            
        }
        
        socket.on("quitRoomUpdate") { data, ack in
            GameService.shared.inRoom = nil
            NotificationCenter.default.post(name: .quitRoomNotification, object: nil)
        }
        
        socket.on("startGameUpdate") { data, ack in
            let roleJSON = data[0] as! String
            GameService.shared.startGame(role: roleJSON)
            NotificationCenter.default.post(name: .gameStartedNotification, object: nil)
        }
        
        socket.on("startRoundUpdate") { data, ack in
            let alivePlayerListJSON = data[0] as! [[String: Any]]
            var alivePlayerList: [Player] = []
            for player in alivePlayerListJSON {
                alivePlayerList.append(try! Player(playerInfo: player))
            }
            GameService.shared.inRoom?.alivePlayerList = alivePlayerList
            NotificationCenter.default.post(name: .updateAlivePlayersNotification, object: nil)
        }

    }
    
    
    func establishConnection(timeOutHandler: @escaping ()->Void){
        socket.connect(timeoutAfter: 2, withHandler: timeOutHandler)
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    
    func sendCreateRoomEvent(newRoom: Room) {
        socket.emit("createRoom", newRoom.toDict())

    }
    
    
    func sendJoinRoomEvent(roomToJoin: SimpleRoom) {
        socket.emit("userJoinRoom", roomToJoin.roomTag)
    }
    
    func sendUserExitRoomEvent() {
        socket.emit("userExitRoom")
    }
    
    func deleteRoomEvent(){
        socket.emit("deleteRoom")
    }
    
    func startGame() {
        socket.emit("startGame")
    }
    
    func startRound() {
        socket.emit("startRound")
    }
    
    func votedFor(chosenPlayerSid: String, time: String) {
        //let thisPlayerVoteFor = GameService.shared.thisPlayer.voteFor
        socket.emit("votedFor", chosenPlayerSid, time)
    }
    
}




extension Notification.Name {
    static let connectedToServerNotification = Notification.Name(rawValue: "connectedToServerNotification")
    static let updateRoomsTableNotification = Notification.Name(rawValue: "updateRoomsTableNotification")
    static let updateRoomNotification = Notification.Name(rawValue: "updateRoomNotification")
    static let quitRoomNotification = Notification.Name(rawValue: "quitRoomNotification")
    static let updateAlivePlayersNotification = Notification.Name(rawValue: "updateAlivePlayersNotification")
    static let gameStartedNotification = Notification.Name(rawValue: "gameStartedNotification")
}
