//
//  NonogramsTests.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class RunsTest: XCTestCase {
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testAllUnknown() {
        let row = Mark.parse("_______________")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 0)
    }
    
    func testAllUnknown2() {
        let row = Mark.parse("_______________")
        let runs = runsEx(row, of: .unknown)
        
        XCTAssert(runs.count == 1)
        XCTAssert(runs[0].start == 0)
        XCTAssert(runs[0].length == 15)
    }
    
    func testAllUnkown3() {
        let row = Mark.parse("_______________")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 0)
    }
    
    func testRuns1() {
        let row = Mark.parse("▓______________")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 1)
        XCTAssert(runs[0].start == 0)
        XCTAssert(runs[0].length == 1)
    }
    
    func testRuns2() {
        let row = Mark.parse("▓▓_____________")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 1)
        XCTAssert(runs[0].start == 0)
        XCTAssert(runs[0].length == 2)
    }
    
    func testRuns3() {
        let row = Mark.parse("_▓▓____________")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 1)
        XCTAssert(runs[0].start == 1)
        XCTAssert(runs[0].length == 2)
    }
    
    func testRuns4() {
        let row = Mark.parse("_____________▓▓")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 1)
        XCTAssert(runs[0].start == 13)
        XCTAssert(runs[0].length == 2)
    }
    
    func testRuns5() {
        let row = Mark.parse("_____▓▓▓▓____▓▓")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 2)
        XCTAssert(runs[0].start == 5)
        XCTAssert(runs[0].length == 4)
        XCTAssert(runs[1].start == 13)
        XCTAssert(runs[1].length == 2)
    }
    
    func testRuns6() {
        let row = Mark.parse("_____▓▓▓▓__x_▓▓")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 2)
        XCTAssert(runs[0].start == 5)
        XCTAssert(runs[0].length == 4)
        XCTAssert(runs[1].start == 13)
        XCTAssert(runs[1].length == 2)
    }
    
    func testRuns7() {
        let row = Mark.parse("xxxxx▓▓▓▓xxxx▓▓")
        let runs = runsEx(row, of: .chiseled)
        
        XCTAssert(runs.count == 2)
        XCTAssert(runs[0].start == 5)
        XCTAssert(runs[0].length == 4)
        XCTAssert(runs[1].start == 13)
        XCTAssert(runs[1].length == 2)
    }
    
    func testRuns8() {
        let row = Mark.parse("______x__x_▓▓__")
        let runs = runsEx(row, of: .chiseled, hints: [1, 4])
        
        XCTAssertEqual(runs.count, 1)
        XCTAssertEqual(runs[0].start, 11)
        XCTAssertEqual(runs[0].length, 2)
        XCTAssertEqual(runs[0].associatedHintIndex, 1)
        XCTAssertEqual(runs[0].associatedPath, 10..<15)
    }
}
