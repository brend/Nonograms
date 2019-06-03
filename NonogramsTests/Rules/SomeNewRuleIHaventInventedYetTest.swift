//
//  SomeNewRuleIHaventInventedYetTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 03.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class SomeNewRuleIHaventInventedYetTest: XCTestCase {

    class SomeNewRuleIHaventInventedYet: Rule {
        
    }
    
    let rule = SomeNewRuleIHaventInventedYet()
    
    func testTheNewRule() {
        let row      = Mark.parse("_______▓_xxxx▓▓")
        let expected = Mark.parse("____▓▓▓▓_xxxx▓▓")
        let actual = rule.apply(to: row, hints: [1, 5, 2])
        
        XCTAssertEqual(actual, expected)
    }

}
