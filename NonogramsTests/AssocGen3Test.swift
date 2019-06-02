//
//  AssocGen3Test.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class AssocGen3Test: XCTestCase {
    
    override func setUp() {
    }
    
    override func tearDown() {
    }
    
    func testAssoc1() {
        let row = Mark.parse("|_|_|_|_|_|x|_|▓|_|x|_|_|_|_|_|")
        let runs = runsEx(row, of: .chiseled, hints: [3, 3, 3])
        
        XCTAssertEqual(runs.count, 1)
        XCTAssertEqual(runs[0].associatedHintIndex, 1)
        XCTAssertEqual(runs[0].associatedPath, (6..<9))
        
    }
}
