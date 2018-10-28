//
//  ImageListViewerTests.swift
//  ImageListViewerTests
//
//  Created by khusboo on 23/10/18.
//  Copyright © 2018 Khusboo. All rights reserved.
//

import XCTest
@testable import ImageListViewer

class ImageListViewerTests: XCTestCase {
    
    var homeControllerUnderTest : HomeViewController!
    var sessionMock : URLSessionMock?
    override func setUp() {
        super.setUp()
        homeControllerUnderTest = HomeViewController()
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "response", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: [])
        
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        //Mock Session URL
        sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func test_countryDetail_Data() {
        // given
        let promise = expectation(description: "Status code: 200")
        
        // when
        XCTAssertEqual(homeControllerUnderTest?.countryDetailArray.count, 0, "countryDetail should be empty before the data task runs")
        let url = URL(string: "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json")
        let dataTask = sessionMock?.dataTask(with: url!) {
            data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    promise.fulfill()
                    do {
                        let countryData = try JSONDecoder().decode(Country.self, from: data!)
                        if let countryDetail = countryData.rows{
                            self.homeControllerUnderTest.countryDetailArray = countryDetail
                        }
                        
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
        dataTask?.resume()
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertEqual(homeControllerUnderTest?.countryDetailArray.count, 3, "Didn't parse 3 items from Mock response")
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        homeControllerUnderTest = nil
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
    
}
