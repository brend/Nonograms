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
    
    func testGen6() {
        let row = Mark.parse("x▓▓x_x_▓__")
        let hints = [2, 2]
        let runs: [Run] = runsEx(row, of: .chiseled, hints: hints)
        let expected: [Run] = [Run(start: 1, length: 2, associatedHintIndex: 0),
                        Run(start: 7, length: 1, associatedHintIndex: 1)]
        
        XCTAssertEqual(expected.count, runs.count)
        XCTAssertEqual(expected[0].start, runs[0].start)
        XCTAssertEqual(expected[0].length, runs[0].length)
        XCTAssertEqual(expected[0].associatedHintIndex, runs[0].associatedHintIndex)
        XCTAssertEqual(expected[1].start, runs[1].start)
        XCTAssertEqual(expected[1].length, runs[1].length)
        XCTAssertEqual(expected[1].associatedHintIndex, runs[1].associatedHintIndex)
    }
    
    func testGen6_Danger() {
        let row = Mark.parse("x▓_▓xx_▓__")
        let hints = [3, 2]
        let runs: [Run] = runsEx(row, of: .chiseled, hints: hints)
        let expected: [Run] = [Run(start: 1, length: 1, associatedHintIndex: 0),
                               Run(start: 3, length: 1, associatedHintIndex: 0),
                               Run(start: 7, length: 1, associatedHintIndex: 1)]
        
        XCTAssertEqual(expected.count, runs.count)
        XCTAssertEqual(expected[0].start, runs[0].start)
        XCTAssertEqual(expected[0].length, runs[0].length)
        XCTAssertEqual(expected[0].associatedHintIndex, runs[0].associatedHintIndex)
        XCTAssertEqual(expected[1].start, runs[1].start)
        XCTAssertEqual(expected[1].length, runs[1].length)
        XCTAssertEqual(expected[1].associatedHintIndex, runs[1].associatedHintIndex)
        XCTAssertEqual(expected[2].start, runs[2].start)
        XCTAssertEqual(expected[2].length, runs[2].length)
        XCTAssertEqual(expected[2].associatedHintIndex, runs[2].associatedHintIndex)
    }
    
    func testGen7() {
        let row      = Mark.parse("|x|_|▓|_|_|▓|▓|x|▓|▓|_|_|▓|_|x|")
        let hints = [1, 3, 3, 1]
        let expected: [Run] =
            [Run(start:  2, length: 1, associatedHintIndex: 0, associatedPath: 1..<7),
             Run(start:  5, length: 2, associatedHintIndex: 1, associatedPath: 1..<7),
             Run(start:  8, length: 2, associatedHintIndex: 2, associatedPath: 8..<14),
             Run(start: 12, length: 1, associatedHintIndex: 3, associatedPath: 8..<14)]
        let actual: [Run] = runsEx(row, of: .chiseled, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
}
