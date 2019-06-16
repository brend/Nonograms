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
    
    func testPlacements1() {
        // 2 3   __x___x___
        let hints = [2, 3]
        let p0 = Path(0..<2), p1 = Path(3..<6), p2 = Path(7..<10)
        let emptyPaths = [p0, p1, p2]
        let expected = [[Placement(hintIndex: 0, path: p0), Placement(hintIndex: 1, path: p1)],
                        [Placement(hintIndex: 0, path: p0), Placement(hintIndex: 1, path: p2)],
                        [Placement(hintIndex: 0, path: p1), Placement(hintIndex: 1, path: p2)]]
        let actual = findAllPlacements(hints: hints,
                                       hintIndicesToDistribute: [0, 1],
                                       emptyPaths: emptyPaths)
                
        XCTAssertEqual(expected, actual)
    }

    func testPlacements2() {
        // 2 3   ____x▓x___
        //       0123456789
        let hints = [2, 3]
        let p0 = Path(0..<4), p1 = Path(7..<10)
        let emptyPaths = [p0, p1]
        let expected = [[Placement(hintIndex: 0, path: p0), Placement(hintIndex: 1, path: p1)]]
        let actual = findAllPlacements(hints: hints,
                                       hintIndicesToDistribute: [0, 1],
                                       emptyPaths: emptyPaths)
        
        XCTAssertEqual(expected, actual)
    }
    
//    func testPlacements3() {
//        // 2 3   ______x___
//        //       0123456789
//        let hints = [2, 3]
//        let p0 = Path(0..<6), p1 = Path(7..<10)
//        let emptyPaths = [p0, p1]
//        let expected = [[Placement]]()
//        let actual = findAllPlacements(hints: hints,
//                                       hintIndicesToDistribute: [0, 1],
//                                       emptyPaths: emptyPaths)
//
//        XCTAssertEqual(expected, actual)
//    }

    func testPlacements4() {
        let hints = [4, 1]
        let p0 = Path(4..<8), p1 = Path(9..<15)
        let emptyPaths = [p0, p1]
        let expected = [[Placement]]()
        let actual = findAllPlacements(hints: hints, hintIndicesToDistribute: hints, emptyPaths: emptyPaths)
        
        XCTAssertEqual(expected, actual)
    }
}
