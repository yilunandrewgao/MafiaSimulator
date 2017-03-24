//
//  PlayerServiceTest.swift
//  MafiaGame
//
//  Created by Yufang Lin on 3/23/17.
//  Copyright © 2017 Yufang Lin. All rights reserved.
//

import XCTest
@testable import MafiaGame

class PlayerServiceTests: XCTestCase {
    
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
    
    
    func testPlayerCategory() {
        let playerInfoService = PlayerService.shared.playerCategory()
        
        if let fetchResult = playerInfoService.sections{
            XCTAssertGreaterThan(fetchResult.count, 0)
            if let fetchResultObjects = fetchResult.first{
                XCTAssertGreaterThan(fetchResultObjects.numberOfObjects, 0)
            }
            else {
                XCTFail()
            }
        }
        else {
            XCTFail()
        }
        
    }
    
    func testRooms() {
        let roomsService = PlayerService.shared.rooms()
        
        if let fetchResult = roomsService.sections{
            XCTAssertGreaterThan(fetchResult.count, 0)
            if let fetchResultObjects = fetchResult.first{
                XCTAssertGreaterThan(fetchResultObjects.numberOfObjects, 0)
            }
            else {
                XCTFail()
            }
        }
        else {
            XCTFail()
        }
    }
    
    func testGameData() {
        let gameDataService = PlayerService.shared.gameData()
        
        if let fetchResult = gameDataService.sections{
            XCTAssertGreaterThan(fetchResult.count, 0)
            if let fetchResultObjects = fetchResult.first{
                XCTAssertGreaterThan(fetchResultObjects.numberOfObjects, 0)
            }
            else {
                XCTFail()
            }
        }
        else {
            XCTFail()
        }
    }
    
}
