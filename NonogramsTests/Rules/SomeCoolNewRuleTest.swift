//
//  SomeCoolNewRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class SomeCoolNewRuleTest: XCTestCase {
    
    class SomeCoolNewRule: Rule {
        override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
            return row
        }
    }
    
    let rule = SomeCoolNewRule()

    func test1() {
        let row      = Mark.parse("|x|_|▓|_|_|▓|▓|x|▓|▓|_|_|▓|_|x|")
        let hints = [1, 3, 3, 1]
        let expected = Mark.parse("|x|_|▓|_|▓|▓|▓|x|▓|▓|▓|_|▓|_|x|")
        let actual = rule.applyExhaustively(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }

}
