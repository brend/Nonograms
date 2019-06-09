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

}
