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
    
    let socket: SocketIOClient = SocketIOClient(socketURL: URL(string: "http://192.168.1.15:7777")!, config: [.log(false), .forceWebsockets(true), .reconnects(false)])


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
            GameService.shared.thisPlayer.isAlive = false
            for player in alivePlayerList {
                if GameService.shared.thisPlayer.sid == player.sid {
                    GameService.shared.thisPlayer.isAlive = true
                }
            }
            
            // reset chat
            GameService.shared.inRoom?.resetChat()
            NotificationCenter.default.post(name: .updateAlivePlayersNotification, object: nil)
        }
        
        socket.on("votedForUpdate") { data, ack in
            let voteCountDicJSON = data[0] as! [String: Int]
            GameService.shared.inRoom?.voteCountDic = voteCountDicJSON
            NotificationCenter.default.post(name: .updateVoteCountNotification, object: nil)
            
        }
        
        socket.on("killedUpdate") { data, ack in
            let killedPlayerJSON = data[0] as! String
            GameService.shared.inRoom?.killedPlayerSid = killedPlayerJSON
            NotificationCenter.default.post(name: .updateKilledNotification, object: nil)
        }
        
        socket.on("endGameUpdate") { data, ack in
            let whoWonJSON = data[0] as! String
            GameService.shared.inRoom?.whoWon = whoWonJSON
            
            //get rather this player won or lost
            if whoWonJSON == "villagers" {
                //if player is a winner/villager
                if GameService.shared.thisPlayer.role == "villager" {
                    //check to see if thisPlayer already won some games or not
                    PlayerService.shared.wonSet()
                }
                else {
                    PlayerService.shared.lostSet()
                }
            }
            else {
                if GameService.shared.thisPlayer.role == "mafia" {
                    PlayerService.shared.wonSet()
                }
                else {
                    PlayerService.shared.lostSet()
                }
            }
            NotificationCenter.default.post(name: .whoWonNotification, object: nil)
        }
        
        socket.on("postMessageUpdate") { data, ack in
            let newChatMessage = data[0] as! [String:String]
            GameService.shared.inRoom?.chatHistory?.append(newChatMessage)
            NotificationCenter.default.post(name: .updateChatNotification, object: nil)
        }
        
        socket.on("hostedRoomUpdate") { data, ack in
            PlayerService.shared.hostedSet()
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
    
    func chatUpdate(message:String) {
        socket.emit("postMessage", message)
    }
    
    //when game is over, players exit
    func gameOverExit() {
        socket.emit("gameOverExit")
    }
    
}




extension Notification.Name {
    static let connectedToServerNotification = Notification.Name(rawValue: "connectedToServerNotification")
    static let updateRoomsTableNotification = Notification.Name(rawValue: "updateRoomsTableNotification")
    static let updateRoomNotification = Notification.Name(rawValue: "updateRoomNotification")
    static let quitRoomNotification = Notification.Name(rawValue: "quitRoomNotification")
    static let updateAlivePlayersNotification = Notification.Name(rawValue: "updateAlivePlayersNotification")
    static let gameStartedNotification = Notification.Name(rawValue: "gameStartedNotification")
    static let updateVoteCountNotification = Notification.Name(rawValue: "updateVoteCountNotification")
    
    //update killed player
    static let updateKilledNotification = Notification.Name(rawValue: "updateKilledNotification")
    
    //update whoWon
    static let whoWonNotification = Notification.Name(rawValue: "whoWonNotification")
    
    static let updateChatNotification = Notification.Name(rawValue: "updateChatNotification")
}
