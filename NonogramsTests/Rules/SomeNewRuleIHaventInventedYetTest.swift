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
    
    let rule = FullFirstHintAssociatedRule()
    
    func testTheNewRule() {
        let row      = Mark.parse("_______▓_xxxx▓▓")
        let hints = [1, 5, 2]
        let expected = Mark.parse("____▓▓▓▓_xxxx▓▓")
        let actual = rule.apply(to: row, hints: hints)
        
        // should be full first hint rule, on a shrunken array, if last run can be associated with hint "2"
        
        XCTAssertEqual(actual, expected)
    }

}
