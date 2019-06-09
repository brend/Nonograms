//
//  SomeNewRuleIHaventInventedYetTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 03.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class CloseToLeftAssociatedRuleTest: XCTestCase {

    let rule = CloseToLeftAssociatedRule()
    
    func testTheNewRule() {
        let row      = Mark.parse("▓▓xxxx_▓_______")
        let hints = [1, 5, 2]
        let expected = Mark.parse("▓▓xxxx_▓▓▓▓____")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(actual, expected)
    }
    
    func testTheNewRuleBackwards() {
        let row      = Mark.parse("_______▓_xxxx▓▓")
        let hints = [1, 5, 2]
        let expected = Mark.parse("____▓▓▓▓_xxxx▓▓")
        let actual = rule.applyExhaustively(to: row, hints: hints)
        
        // should be full first hint rule, on a shrunken array, if last run can be associated with hint "2"
        
        XCTAssertEqual(actual, expected)
    }
    
    func test3() {
        let row      = Mark.parse("_______▓__xxx▓_")
        let hints = [1, 5, 2]
        
        XCTAssertNoThrow(rule.apply(to: row, hints: hints))
    }

    func test4() {
        let row      = Mark.parse("|x|_|▓|_|_|▓|▓|x|▓|▓|_|_|▓|_|x|")
        let hints = [1, 3, 3, 1]
        let expected = Mark.parse("|x|_|▓|_|▓|▓|▓|x|▓|▓|▓|_|▓|_|x|")
        let actual = rule.applyExhaustively(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
}
