//
//  PathsTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class PathsTest: XCTestCase {

    func testPathsAssoc1() {
        let row = Mark.parse("|_|_|_|_|_|x|_|▓|_|x|_|_|_|_|_|")
        let paths = pathsEx(row, hints: [3, 3, 3])
        
        XCTAssertEqual(paths.count, 3)
        XCTAssertEqual(paths[0], Path(start: 0, length: 5, associatedHintIndex: 0))
        XCTAssertEqual(paths[1], Path(start: 6, length: 3, associatedHintIndex: 1))
        XCTAssertEqual(paths[2], Path(start: 10, length: 5, associatedHintIndex: 2))
    }
    
    func testPathsAssoc2() {
        let row = Mark.parse("|_|_|_|_|_|_|x|_|▓|_|x|_|_|_|_|_|")
        let paths = pathsEx(row, hints: [3, 3, 3])
        
        XCTAssertEqual(paths.count, 3)
        XCTAssertEqual(paths[0], Path(start: 0, length: 6, associatedHintIndex: 0))
        XCTAssertEqual(paths[1], Path(start: 7, length: 3, associatedHintIndex: 1))
        XCTAssertEqual(paths[2], Path(start: 11, length: 5, associatedHintIndex: 2))
    }
    
    func testPathsAssoc3() {
        let row = Mark.parse("|_|_|_|_|_|_|_|x|_|▓|_|x|_|_|_|_|_|")
        let paths = pathsEx(row, hints: [3, 3, 3])
        
        XCTAssertEqual(paths.count, 3)
        XCTAssertEqual(paths[0], Path(start: 0, length: 7, associatedHintIndex: nil))
        XCTAssertEqual(paths[1], Path(start: 8, length: 3, associatedHintIndex: nil))
        XCTAssertEqual(paths[2], Path(start: 12, length: 5, associatedHintIndex: nil))
    }

}
