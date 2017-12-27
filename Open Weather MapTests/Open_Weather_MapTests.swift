//
//  Open_Weather_MapTests.swift
//  Open Weather MapTests
//
//  Created by Parthiban on 12/26/17.
//  Copyright © 2017 parthi. All rights reserved.
//

import XCTest
@testable import Open_Weather_Map

//Comment : for time being - only Unit tests are added - UI tests are not added

class Open_Weather_MapTests: XCTestCase {
    
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

    func testURL() {
        
        if let _ = OWMUtilities.citySearchURLFor(text: "new") {
            XCTAssert(true, "citySearchURLFor works fine for new")
        }
        else {
            XCTAssert(false, "citySearchURLFor works fine for new")
        }

    }
    
    func testNetwork() {
        
        if Reachability.forInternetConnection().isReachable() {
            XCTAssert(true, "internet available")
        }
        else {
            XCTAssert(false, "internet needed for testing")
        }
        
    }
    
    func testAPI() {
        
        //Comment : new - succeeds ; blahblahblah - fails -- we could setup a test database and iterate through multiple search texts here and log all results
        OWMServiceManager.sharedInstance.getCitiesFor(searchText: "blahblahblah", completion: { error, response in
            
            if let err = error {
                XCTAssert(false, err.localizedDescription)
            }
            else {
                
                guard let respData = response else {
                    
                    XCTAssert(false, "getCitiesFor blahblahblah failed - response nil")
                    
                    return
                }
                
                if respData.cityList.count > 0 {
                    XCTAssert(true, "getCitiesFor blahblahblah exists - success")
                }
                else {
                    XCTAssert(false, "getCitiesFor blahblahblah des not exist - fail")
                }
            }
        })
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
