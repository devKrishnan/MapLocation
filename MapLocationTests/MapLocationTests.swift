//
//  MapLocationTests.swift
//  MapLocationTests
//
//  Created by radhakrishnan S on 01/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import XCTest
@testable import MapLocation

class MapLocationTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
       
        let parser = JSONParser()
        let path = Bundle.main.path(forResource: "mapInfo", ofType: "json")
        do {
            let data : NSData = try NSData(contentsOfFile: path!)
            let results = parser.locationResults(data: data as Data)
            XCTAssertNotNil(results,"JSON invalid")
        } catch  {
            print("Data invalid ")
        }
        
       
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
