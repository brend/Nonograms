//
//  MarkFinishedRunTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 15.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class MarkFinishedRunRuleTest: XCTestCase {
    
    let rule = MarkFinishedRunRule()
    
    func test1() {
        let row      = Mark.parse("|x|x|▓|_|_|_|_|_|▓|▓|▓|▓|_|_|_|_|_|▓|x|x|")
        //                          0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9
        let hints = [1, 8, 1]
        let expected = Mark.parse("|x|x|▓|x|_|_|_|_|▓|▓|▓|▓|_|_|_|_|x|▓|x|x|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func test2() {
        let row      = Mark.parse("|_|_|_|▓|_|▓|_|_|_|_|▓|_|_|_|_|")
        let hints = [4, 1, 1]
        let expected = Mark.parse("|_|_|_|▓|_|▓|_|_|_|_|▓|_|_|_|_|")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }

}
