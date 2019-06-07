//
//  SumWithSpacesRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 05.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class SumWithSpacesRuleTest: XCTestCase {

    let rule = SumWithSpacesRule()
    
    func testSumWithSpaces1() {
        let row      = Mark.parse("|x|x|▓|x|_|_|_|x|_|_|_|x|▓|x|x|")
        let expected = Mark.parse("|x|x|▓|x|▓|x|▓|x|▓|x|▓|x|▓|x|x|")
        let hints = [1, 1, 1, 1, 1, 1]
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSumWithSpaces2() {
        let row      = Mark.parse("|x|_|_|_|_|_|_|_|_|_|_|x|▓|x|x|")
        let expected = row
        let hints = [1, 1, 1, 1, 1, 1]
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSumWithSpaces3() {
        let row      = Mark.parse("|x|_|_|x|_|_|_|_|x|_|_|x|▓|x|x|")
        let hints = [2, 4, 2, 1]
        let expected = Mark.parse("|x|▓|▓|x|▓|▓|▓|▓|x|▓|▓|x|▓|x|x|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSumWithSpaces4() {
        let row      = Mark.parse("|x|_|_|_|x|")
        let hints = [1, 1]
        let expected = Mark.parse("|x|▓|x|▓|x|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSumWithSpaces5() {
        let row      = Mark.parse("|x|_|_|_|_|")
        let hints = [1, 1]
        let expected = row
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testSumWithSpaces6() {
        let row      = Mark.parse("|_|_|_|_|_|_|_|_|_|_|x|x|x|▓|x|")
        let hints = [1, 1, 2, 1, 1]
        let expected = row
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
}
