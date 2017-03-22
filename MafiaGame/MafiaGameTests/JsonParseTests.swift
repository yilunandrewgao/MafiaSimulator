//
//  JsonParseTests.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/21/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import XCTest
@testable import MafiaGame

class JsonParseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //test JSON parse extension for player
    
    func testPlayerParse() throws {
        let testPlayerJSON : [String:Any] = ["name": "Anne", "sid" : "3402358"]
        let testPlayerObject = try Player(playerInfo: testPlayerJSON)
        
        //get dictionary values from keys
        let playerNameDic = testPlayerJSON["name"]
        let playerSidDic = testPlayerJSON["sid"]
        
        //test to make sure Player.name and the dictionary name matches
        if let playerName = playerNameDic {
            
            XCTAssertEqual(String(describing: playerName), testPlayerObject.name)
        }
        else {
            //faile if testPlayerObject was not successfully created
            XCTFail()
        }
        
        
        //test to make sure Player.sid matches the dictionary sid
        if let playerSid = playerSidDic {
            XCTAssertEqual(String(describing: playerSid), testPlayerObject.sid)
            
        }
        else {
            XCTFail()
        }
        
    }
    
    
    //test JSON parse extension for room
    func testRoomParse() throws {
        let testRoomJSON = ["playerList": [["name": "Anne", "sid": "342342"], ["name": "Matt", "sid": "234235"]], "roomName": "HelloWorld", "maxPlayers": 4, "owner": ["name": "Anne", "sid": "243562"], "password": "42", "gameStarted": false] as [String : Any]
        let testRoomObject = try Room(json: testRoomJSON)
        
        //get dictionary values from keys
        let roomNameDic = testRoomJSON["roomName"]
        let roomMaxPlayersDic = testRoomJSON["maxPlayers"]
        let roomPasswordDic = testRoomJSON["password"]
        let roomGameStartedDic = testRoomJSON["gameStarted"]
        
        
        //test Room.roomName equals dictionary roomName
        if let roomName = roomNameDic {
            XCTAssertEqual(String(describing: roomName), testRoomObject.roomName)
        }
        else {
            XCTFail()
        }
        
        //test Room.maxPlayers is equal dictionary maxPlayers
        if let roomMaxPlayers = roomMaxPlayersDic {
            let maxPlayers = roomMaxPlayers as! Int
            XCTAssertEqual(maxPlayers, testRoomObject.maxPlayers)
        }
        else {
            XCTFail()
        }
        
        //test Room.password is equal dictionary password
        if let roomPassword = roomPasswordDic {
            XCTAssertEqual(String(describing: roomPassword), testRoomObject.password)
        }
        else {
            XCTFail()
        }
        
        //test Room.gameStarted is equal dictionary gameStarted
        if let roomGameStarted = roomGameStartedDic {
            let gameStarted = roomGameStarted as! Bool
            XCTAssertEqual(gameStarted, testRoomObject.gameStarted)
        }
        else {
            XCTFail()
        }
        
    }
    
    
    //test JSON parse extension for simple room
    func testSimpleRoomParse() throws {
        let testSimpleRoomJSON : [String:Any] = ["currentNumPlayers": 3, "roomName": "MeMeMe", "maxPlayers": 4, "owner": ["name": "Anne", "sid": "234562"], "password": "42", "roomTag": "MeMeMe", "gameStarted": true]
        let testSimpleRoomObject = try SimpleRoom(json: testSimpleRoomJSON)
        
        //get dictionary keys
        let currNumPlayersDic = testSimpleRoomJSON["currentNumPlayers"]
        let roomNameDic = testSimpleRoomJSON["roomName"]
        let roomMaxPlayersDic = testSimpleRoomJSON["maxPlayers"]
        let roomPasswordDic = testSimpleRoomJSON["password"]
        let roomTagDic = testSimpleRoomJSON["roomTag"]
        let roomGameStartedDic = testSimpleRoomJSON["gameStarted"]
        
        
        //test SimpleRoom.numPlayers is equal to dictionary currentNumPlayers
        if let currNumPlayers = currNumPlayersDic {
            let numPlayers = currNumPlayers as! Int
            XCTAssertEqual(numPlayers, testSimpleRoomObject.numPlayers)
        }
        else {
            XCTFail()
        }
        
        //test SimpleRoom.roomName is equal to dictionary roomName
        if let roomName = roomNameDic {
            XCTAssertEqual(String(describing: roomName), testSimpleRoomObject.roomName)
        }
        else {
            XCTFail()
        }
        
        
        //test SimpleRoom.maxPlayers is equal to dictionary maxPlayers
        if let roomMaxPlayers = roomMaxPlayersDic {
            let maxPlayers = roomMaxPlayers as! Int
            XCTAssertEqual(maxPlayers, testSimpleRoomObject.maxPlayers)
        }
        else{
            XCTFail()
        }
        
        
        //test SimpleRoom.password is equal to dictionary password
        if let password = roomPasswordDic {
            XCTAssertEqual(String(describing: password), testSimpleRoomObject.password)
        }
        else{
            XCTFail()
        }
        
        
        //test SimpleRoom.roomTag is equal to dictionary roomTag
        if let roomTag = roomTagDic {
            XCTAssertEqual(String(describing: roomTag), testSimpleRoomObject.roomTag)
        }
        else{
            XCTFail()
        }
        
        
        //test SimpleRoom.gameStarted is equal to dictionary gameStarted
        if let roomGameStarted = roomGameStartedDic {
            let gameStarted = roomGameStarted as! Bool
            XCTAssertEqual(gameStarted, testSimpleRoomObject.gameStarted)
        }
        else{
            XCTFail()
        }
        
    }
}
