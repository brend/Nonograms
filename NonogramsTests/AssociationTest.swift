//
//  AssociationTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 05.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class AssociationTest: XCTestCase {
    
    var association: Association!
    
    override func setUp() {
        association = Association()
    }

    func testAssociation1() {
        //   1 2  _|_|_|x|x|x|x|_|_|_
        //        0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 3),
                        Channel(startIndex: 7, length: 3)]
        let hints = [1, 2]
        let expected = [Channel(startIndex: 0, length: 3, associatedHintIndex: 0),
                        Channel(startIndex: 7, length: 3, associatedHintIndex: 1)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation2() {
        //   1 2  _|_|_|x|x|x|_|_|_|_
        //        0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 3),
                        Channel(startIndex: 6, length: 4)]
        let hints = [1, 2]
        let expected = channels
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation3() {
        //   1 3  _|_|x|_|_|x|x|_|_|_
        //        0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 2),
                        Channel(startIndex: 3, length: 2),
                        Channel(startIndex: 7, length: 3)]
        let hints = [1, 3]
        let expected =  [Channel(startIndex: 0, length: 2),
                         Channel(startIndex: 3, length: 2),
                         Channel(startIndex: 7, length: 3, associatedHintIndex: 1)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation4() {
        //   2 3  _|_|x|_|x|x|x|_|_|_
        //        0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 2),
                        Channel(startIndex: 3, length: 1),
                        Channel(startIndex: 7, length: 3)]
        let hints = [2, 3]
        let expected = [Channel(startIndex: 0, length: 2),
                        Channel(startIndex: 3, length: 1),
                        Channel(startIndex: 7, length: 3, associatedHintIndex: 1)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation5() {
        //   2 1 3  _|_|x|_|x|x|_|_|_|_
        //          0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 2),
                        Channel(startIndex: 3, length: 1),
                        Channel(startIndex: 6, length: 4)]
        let hints = [2, 1, 3]
        let expected = [Channel(startIndex: 0, length: 2, associatedHintIndex: 0),
                        Channel(startIndex: 3, length: 1, associatedHintIndex: 1),
                        Channel(startIndex: 6, length: 4, associatedHintIndex: 2)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation6() {
        //   4 1 1 4  _ |_ |_ |_ |x |x |_ |_ |_ |x |_ |_ |_ |_
        //            0  1  2  3  4  5  6  7  8  9  10 11 12 13
        
        let channels = [Channel(startIndex: 0, length: 4),
                        Channel(startIndex: 6, length: 3),
                        Channel(startIndex: 10, length: 4)]
        let hints = [4, 1, 1, 4]
        let expected = [Channel(startIndex: 0, length: 4, associatedHintIndex: 0),
                        Channel(startIndex: 6, length: 3),
                        Channel(startIndex: 10, length: 4, associatedHintIndex: 3)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testMaxHintMustntMatchTooMuch() {
        //   2 1 3  _|_|_|_|_|_|_|_|_|_
        //          0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 10)]
        let hints = [2, 1, 3]
        let expected = channels
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testMaxHintMayMatchEnough() {
        //   3 1 2  _|_|_|_|x|_|_|x|_|_
        //          0 1 2 3 4 5 6 7 8 9
        
        let channels = [Channel(startIndex: 0, length: 4),
                        Channel(startIndex: 5, length: 2),
                        Channel(startIndex: 8, length: 2)]
        let hints = [3, 1, 2]
        let expected = [Channel(startIndex: 0, length: 4, associatedHintIndex: 0),
                        Channel(startIndex: 5, length: 2, associatedHintIndex: 1),
                        Channel(startIndex: 8, length: 2, associatedHintIndex: 2)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
    func testAssociation8() {
        //     3 3 3  _ |_ |_ |_ |_ |_ |x |_ |_ |_ |x |_ |_ |_ |_ |_
        //            0  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
        
        let channels = [Channel(startIndex: 0, length: 5),
                        Channel(startIndex: 7, length: 3),
                        Channel(startIndex: 11, length: 5)]
        let hints = [3, 3, 3]
        let expected = [Channel(startIndex: 0, length: 5, associatedHintIndex: 0),
                        Channel(startIndex: 7, length: 3, associatedHintIndex: 1),
                        Channel(startIndex: 11, length: 5, associatedHintIndex: 2)]
        let actual = association.associate(channels: channels, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
}
