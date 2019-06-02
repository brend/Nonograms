//
//  AssocGen2Test.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class AssocGen2Test: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testAssoc1() {
        let row = Mark.parse("xx▓▓x_▓___x_▓_")
        let runs = runsEx(row, of: .chiseled, hints: [2, 2, 3])
        
        XCTAssertEqual(runs.count, 3)
        XCTAssertEqual(runs[0].associatedHintIndex, 0)
        XCTAssertEqual(runs[0].associatedPath, (2..<4))
        XCTAssertEqual(runs[1].associatedHintIndex, 1)
        XCTAssertEqual(runs[1].associatedPath, (5..<10))
        XCTAssertEqual(runs[2].associatedHintIndex, 2)
        XCTAssertEqual(runs[2].associatedPath, (11..<14))
    }
    
    func testAssoc2() {
        let row = Mark.parse("xx▓▓x_▓___x___x__x_____xx___xxxx___")
        let runs = runsEx(row, of: .chiseled, hints: [2, 2, 3])
        
        XCTAssertEqual(runs.count, 2)
        XCTAssertEqual(runs[0].associatedHintIndex, 0)
        XCTAssertEqual(runs[0].associatedPath, (2..<4))
        XCTAssertEqual(runs[1].associatedHintIndex, 1)
        XCTAssertEqual(runs[1].associatedPath, (5..<10))
    }
    
    func testAssoc3() {
        let row = Mark.parse("xx▓▓x_▓___x_▓_▓")
        let runs = runsEx(row, of: .chiseled, hints: [2, 2, 3])
        
        XCTAssertEqual(runs.count, 4)
        XCTAssertEqual(runs[0].associatedHintIndex, 0)
        XCTAssertEqual(runs[0].associatedPath, (2..<4))
        XCTAssertEqual(runs[1].associatedHintIndex, 1)
        XCTAssertEqual(runs[1].associatedPath, (5..<10))
        XCTAssertEqual(runs[2].associatedHintIndex, 2)
        XCTAssertEqual(runs[2].associatedPath, (11..<15))
        XCTAssertEqual(runs[3].associatedHintIndex, 2)
        XCTAssertEqual(runs[3].associatedPath, (11..<15))
    }
}
