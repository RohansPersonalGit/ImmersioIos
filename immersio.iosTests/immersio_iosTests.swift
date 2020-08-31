//
//  immersio_iosTests.swift
//  immersio.iosTests
//
//  Created by Rohan Garg on 2020-08-13.
//  Copyright © 2020 Immersio. All rights reserved.
//

import XCTest
@testable import immersio_ios

class immersio_iosTests: XCTestCase {

    var sut: ChatViewController!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
        sut = ChatViewController()
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTokenGen() throws {
        
        sut.generateToken()
        sleep(4)
        print(sut.authToken)
        sut.loadChat()
        sleep(4)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
