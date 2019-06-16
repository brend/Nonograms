//
//  CenterUniqueEmptyPathsRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class CenterUniqueEmptyPathsRuleTest: XCTestCase {

    let rule = CenterUniqueEmptyPathsRule()
    
    func test1() {
        let row      = Mark.parse("▓x__x_x__xxx▓▓▓")
        let hints = [1, 2, 2, 3]
        let expected = Mark.parse("▓x▓▓x_x▓▓xxx▓▓▓")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func test2() {
        let row      = Mark.parse("xxx_x|____x|_____")
        let hints = [1, 2, 1]
        let expected = Mark.parse("xxx_x|____x|_____")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func test3() {
        let row      = Mark.parse("|x|▓|x|_|x|_|_|_|_|▓|▓|_|_|_|_|")
        let hints = [1, 1, 6]
        let expected = row
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }

}
