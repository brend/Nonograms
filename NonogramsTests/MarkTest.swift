//
//  MarkTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
import Nonograms

class MarkTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testParseChiseled() {
        let marks = Mark.parse("▓")
        
        XCTAssert(marks == [.chiseled])
    }
    
    func testParseMarked() {
        let marks = Mark.parse("x")
        
        XCTAssert(marks == [.marked])
    }
    
    func testParseUnknown() {
        let marks = Mark.parse("_")
        
        XCTAssert(marks == [.unknown])
    }
    
    func testRow1() {
        let marks = Mark.parse("___▓▓_x____▓_x_")
        let expected: [Mark] = [.unknown, .unknown, .unknown, .chiseled, .chiseled, .unknown, .marked, .unknown, .unknown, .unknown, .unknown, .chiseled, .unknown, .marked, .unknown]
        
        XCTAssert(marks == expected)
    }

}
