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
    
    func testVectorReflex() {
        var vector = CGVector(dx: 1, dy: 1)
        var reflexVector = CGVector(dx: 1, dy: -1)
        let rect = CGRect(x: 0, y: 0, width: 30, height: 30)
        var line = rect.topLine()
        var reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(reflexVector == reflexVectorB)
        
        line = rect.rightLine()
        reflexVector = CGVector(dx: -1, dy: 1)
        reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(reflexVector == reflexVectorB)
        
        line = Line(a: 1, b: -1, c: 0)
        reflexVector = CGVector(dx: 1, dy: 1)
        reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(reflexVector == reflexVectorB)
        
        vector = CGVector(dx: 1, dy: 2)
        line = Line(a: 1, b: -1, c: 0)
        reflexVector = CGVector(dx: 2, dy: 1)
        reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(reflexVector == reflexVectorB)
        
        vector = CGVector(dx: 1, dy: 1)
        line = Line(slope: 2, intersectionWithY: 0)
        reflexVector = CGVector(dx: 1.0 / 5, dy: 7.0 / 5)
        reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(abs(reflexVector.dx - reflexVectorB.dx) <= 0.0000001)
        XCTAssert(abs(reflexVector.dy - reflexVectorB.dy) <= 0.0000001)
        
        vector = CGVector(dx: 1, dy: 1)
        line = Line(a: 0, b: 1, c: -896)
        reflexVector = CGVector(dx: 1, dy: -1)
        reflexVectorB = vector.reflexVector(line: line)
        XCTAssert(reflexVector == reflexVectorB)
    }
    
    func testLineType() {
        var vector = CGVector(dx: 1, dy: 1)
        var beginP = CGPoint(x: 0, y: 0)
        let rect = CGRect(x: 0, y: 0, width: 10, height: 5)
        var lineType = LineType.bottom
        var lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
        
        vector = CGVector(dx: 1, dy: 0)
        lineType = LineType.right
        lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
        
        vector = CGVector(dx: -1, dy: 0)
        lineType = LineType.left
        lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
        
        vector = CGVector(dx: 0, dy: 1)
        lineType = LineType.bottom
        lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
        
        vector = CGVector(dx: 1, dy: 1)
        beginP = CGPoint(x: 6, y: 3)
        lineType = LineType.bottom
        lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
        
        vector = CGVector(dx: 1, dy: 1)
        beginP = CGPoint(x: 6, y: 1)
        lineType = LineType.right
        lineTypeB = BilliardsPath.whichRectLineVectorInsection(beginP: beginP, vertor: vector, rect: rect)
        XCTAssert(lineType == lineTypeB)
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
