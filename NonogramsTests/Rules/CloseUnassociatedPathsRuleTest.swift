//
//  CloseUnassociatedPathsRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class CloseUnassociatedPathsRuleTest: XCTestCase {
    
    let rule = CloseUnassociatedPathsRule()

    func testClosing() {
        let row = Mark.parse("_______________")
        let altered = rule.apply(to: row, hints: [2, 3])
        
        XCTAssertEqual(row, altered)
    }
    
    func testClosing2() {
        let row = Mark.parse("_______x_______")
        let altered = rule.apply(to: row, hints: [2, 3])
        
        XCTAssertEqual(row, altered)
    }
    
    func testClosing3() {
        let row = Mark.parse("___▓___x_______")
        let altered = rule.apply(to: row, hints: [2, 3])
        
        XCTAssertEqual(row, altered)
    }

    func testClosing4() {
        let row = Mark.parse("___▓___x__▓____")
        let altered = rule.apply(to: row, hints: [2, 3])
        
        XCTAssertEqual(row, altered)
    }
    
    func testClosing5() {
        let row = Mark.parse("___▓___x__▓__x_")
        let altered = rule.apply(to: row, hints: [2, 3])
        let expected = Mark.parse("___▓___x__▓__xx")
        
        XCTAssertEqual(altered, expected)
    }
    
    func testClosing6() {
        let row = Mark.parse("___▓_x_x__▓____")
        let altered = rule.apply(to: row, hints: [2, 3])
        let expected = Mark.parse("___▓_xxx__▓____")
        
        XCTAssertEqual(altered, expected)
    }
}
