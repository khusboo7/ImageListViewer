//
//  ImageListViewerNetworkTest.swift
//  ImageListViewerNetworkTest
//
//  Created by khusboo on 29/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import XCTest
@testable import ImageListViewer

class ImageListViewerNetworkTest: XCTestCase {
    
    var sessionUrlUnderTest: URLSession!

    
    override func setUp() {
        super.setUp()
        sessionUrlUnderTest = URLSession(configuration: URLSessionConfiguration.default)

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sessionUrlUnderTest = nil
        super.tearDown()
    }
    
    func testvalidcallToProcessRequestAPIGetsSuccessStatus200(){
        // given
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let promise = expectation(description: "Status code: 200")
        
        // when
        let dataTask = sessionUrlUnderTest.dataTask(with: url!) { data, response, error in
            // then
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
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
    
}
