//
//  OHTTStubPocTests.swift
//  OHTTStubPocTests
//
//  Created by Nando on 31/01/18.
//  Copyright © 2018 Nando. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import OHTTStubPoc

class OHTTStubPocTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let response = [
            "username" : "feh.wilinando",
            "password" : "123"
                         ]
        
        stub(condition: isHost("api.com.br") && isScheme("http")) { _ in
            return OHHTTPStubsResponse(jsonObject: response, statusCode: 200, headers: .none)
        }
        
        
        let session = URLSession.shared
        
        guard let url = URL(string: "http://api.com.br") else {
            XCTFail("Error on build URL")
            return
        }
        
        let expect = expectation(description: "Calls the callback with a resource object")
        
        let task = session.dataTask(with: url) { (data, urlresponse, error) in
            
            
            guard let httpResponse = urlresponse as? HTTPURLResponse else {
                XCTFail("Cast to HTTPURLResponse fail")
                return
            }
            
            XCTAssertEqual(200, httpResponse.statusCode)
            
            guard error == nil else {
                XCTFail("Error \(error!.localizedDescription)")
                return
            }
            
            guard let data = data  else {
                XCTFail("Data Fail")
                return
            }
            
            
            
            print(String(data: data, encoding: String.Encoding.utf8)!)
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                XCTFail("Json Fail")
                return
            }
            
            guard let result = json as? [String: String] else {
                XCTFail("Cast Dictonary Fail")
                return
            }
            
            
            XCTAssertTrue(result.keys.contains("username"))
            XCTAssertTrue(result.keys.contains("password"))
            XCTAssertEqual("feh.wilinando", result["username"])
            XCTAssertEqual("123", result["password"])
            
            expect.fulfill()
        }
        
        task.resume()
        
        wait(for: [expect], timeout: 0.3)
        
        
        OHHTTPStubs.removeAllStubs()
        
    }

}
