//
//  MarkSmallPathsRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 03.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class MarkSmallPathsRuleTest: XCTestCase {
    
    let rule = MarkSmallPathsRule()
    
    func testMarkSmallPaths1() {
        let row      = Mark.parse("_____________x_")
        let expected = Mark.parse("_____________xx")
        let actual = rule.apply(to: row, hints: [4])
        
        XCTAssertEqual(actual, expected)
    }
    
    
}
