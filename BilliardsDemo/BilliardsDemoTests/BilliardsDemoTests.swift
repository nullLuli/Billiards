//
//  BilliardsDemoTests.swift
//  BilliardsDemoTests
//
//  Created by nullLuli on 2019/7/24.
//  Copyright © 2019 nullLuli. All rights reserved.
//

import XCTest
import BilliardsDemo
import UIKit

class BilliardsDemoTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTimeFunc() {
        let v0: CGFloat = 200
        let a: CGFloat = 10
        
        let controlP = CGPoint(x: 10, y: 2000)
        let endP = CGPoint(x: 20, y: 2000)
        
        if let (controlPB, endPB) = BilliardsTimeFunc.bezierPointsFromMotionParabola(v0: v0, a: a) {
            XCTAssert(controlP.equalTo(controlPB))
            XCTAssert(endP.equalTo(endPB))
        } else {
            XCTAssert(false)
        }
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
