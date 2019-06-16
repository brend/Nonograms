//
//  ShrinkBoundedRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class ShrinkBoundedRuleTest: XCTestCase {

    let rule = ShrinkBoundedRule()
    
    func test1() {
        let row      = Mark.parse("|x|_|_|_|▓|_|▓|▓|▓|_|▓|_|_|_|x|")
        let hints = [1, 7, 1]
        let expected = Mark.parse("|x|_|_|_|▓|▓|▓|▓|▓|▓|▓|_|_|_|x|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
//    func test2() {
//        let row      = Mark.parse("|x|x|_|_|x|▓|▓|▓|_|_|▓|_|_|_|_|")
//        let hints = [3, 1, 1, 3]
//        let expected = Mark.parse("|x|x|_|_|x|▓|▓|▓|_|_|▓|_|_|_|_|")
//        let actual = rule.apply(to: row, hints: hints)
//        
//        XCTAssertEqual(expected, actual)
//    }

}
