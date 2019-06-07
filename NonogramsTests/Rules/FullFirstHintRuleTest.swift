//
//  FullFirstHintRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 06.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class FullFirstHintRuleTest: XCTestCase {
    
    let rule = FullFirstHintRule()

    func testFFH1() {
        let row      = Mark.parse("|_|▓|▓|▓|▓|_|x|_|_|x|_|_|_|▓|x|")
        let hints = [4, 4]
        let expected = Mark.parse("|x|▓|▓|▓|▓|x|x|_|_|x|_|_|_|▓|x|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }

    
}
