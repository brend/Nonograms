//
//  ShrinkAssociatedRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class ShrinkAssociatedRuleTest: XCTestCase {

    let rule = ShrinkAssociatedRule()
    
    func testShrink1() {
        let row      = Mark.parse("|_|_|_|_|_|x|_|▓|_|x|_|_|_|_|_|")
        let expected = Mark.parse("|_|_|_|_|_|x|▓|▓|▓|x|_|_|_|_|_|")
     // let expected = Mark.parse("|_|_|▓|_|_|x|▓|▓|▓|x|_|_|▓|_|_|")
        let altered = rule.apply(to: row, hints: [3, 3, 3])
        
        XCTAssertEqual(altered, expected)
    }
}
