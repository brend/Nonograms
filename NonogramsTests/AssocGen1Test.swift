//
//  AssocGen1Test.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class AssocGen1Test: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testAssoc1() {
        let row = Mark.parse("_____▓▓▓▓__x_▓▓")
        let runs = runsEx(row, of: .chiseled, hints: [5, 3])
        
        XCTAssert(runs.count == 2)
        XCTAssert(runs[0].associatedHintIndex == 0)
        XCTAssert(runs[0].associatedPath == (0..<11))
        XCTAssert(runs[1].associatedHintIndex == 1)
        XCTAssert(runs[1].associatedPath == (12..<15))
    }
    
    func testAssoc2() {
        let row = Mark.parse("___▓_▓▓▓▓__x_▓▓")
        let runs = runsEx(row, of: .chiseled, hints: [6, 3])
        
        XCTAssert(runs.count == 3)
        XCTAssert(runs[0].associatedHintIndex == 0)
        XCTAssert(runs[0].associatedPath == (0..<11))
        XCTAssert(runs[1].associatedHintIndex == 0)
        XCTAssert(runs[1].associatedPath == (0..<11))
        XCTAssert(runs[2].associatedHintIndex == 1)
        XCTAssert(runs[2].associatedPath == (12..<15))
    }
    
    func testAssoc3() {
        // Gen1 cannot separate the two hints if they're not on separate paths
        // to do so would be correct in general but a mistake for Gen1
        let row = Mark.parse("___▓_▓▓▓▓____▓▓")
        let runs = runsEx(row, of: .chiseled, hints: [6, 3])
        
        XCTAssert(runs.count == 3)
        XCTAssert(runs[0].associatedHintIndex == nil)
        XCTAssert(runs[0].associatedPath == nil)
        XCTAssert(runs[1].associatedHintIndex == nil)
        XCTAssert(runs[1].associatedPath == nil)
        XCTAssert(runs[2].associatedHintIndex == nil)
        XCTAssert(runs[2].associatedPath == nil)
    }
    
    func testAssoc4() {
        let row = Mark.parse("_______________")
        let runs = runsEx(row, of: .chiseled, hints: [6, 3])
        
        XCTAssert(runs.isEmpty)
    }
}
