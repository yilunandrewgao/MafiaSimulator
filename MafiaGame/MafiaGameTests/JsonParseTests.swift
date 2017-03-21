//
//  JsonParseTests.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/21/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import XCTest

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
    
    func testPlayerParse() {
        let testPlayerJSON : [String:Any] = ["name": "Anne", "sid" : "3402358"]
    
    }
    
    //test JSON parse extension for room
    func testRoomParse() {
        let testRoomJSON : [String:Any] = ["playerList": [["name": "Anne", "sid": "342342"], ["name": "Matt", "sid": "234235"]], "roomName": "HelloWorld", "maxPlayers": 4, "owner": ["name": "Anne", "sid": "243562"], "password": "42", "gameStarted": true]
        
        
    }
    
    //test JSON parse extension for simple room
    func testSimpleRoomParse() {
        let testSimpleRoomJSON : [String:Any] = ["currentNumPlayers": 3, "roomName": "MeMeMe", "maxPlayers": 4, "owner": ["name": "Anne", "sid": "234562"], "password": "42", "roomTag": "MeMeMe", "gameStarted": true]
    }
}
