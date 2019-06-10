//
//  BenchmarkTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

class BenchmarkTest: XCTestCase {
    
    var puzzle: Puzzle?
    
    override func setUp() {
        puzzle = nil
    }
    
    override func tearDown() {
        puzzle = nil
    }
    
    func bundlePath(for file: String, filetype: String) -> String {
        let bundle = Bundle(for: type(of: self))
        
        guard let path = bundle.path(forResource: file, ofType: filetype)
            else { fatalError("file not found") }
        
        return path
    }
    
    func solve() {
        puzzle!.rules = Rule.defaultSet
        puzzle!.printSteps = false
        
        puzzle!.solve()
    }
    
    func parseAndSolve(matrix filename: String) throws {
        let path = bundlePath(for: filename, filetype: "matrix")
        let matrix = try Matrix.parse(matrixFile: path)
        
        puzzle = Puzzle(solution: matrix)
        
        solve()
    }
    
    func parseAndSolve(pea filename: String) throws {
        let path = bundlePath(for: filename, filetype: "pea")
        
        puzzle = try Puzzle.parse(peaFile: path)
        
        solve()
    }
    
    var isSolved: Bool { return puzzle?.isSolved ?? false }

    func testMarioFace() {
        XCTAssertNoThrow(try parseAndSolve(matrix: "mario_face"))
        XCTAssert(isSolved)
    }
    
    func testBoatPlus() {
        XCTAssertNoThrow(try parseAndSolve(matrix: "boat_plus"))
        XCTAssert(isSolved)
    }
    
    func testNinja() {
        XCTAssertNoThrow(try parseAndSolve(pea: "ninja"))
        XCTAssert(isSolved)
    }
    
    func testStar() {
        XCTAssertNoThrow(try parseAndSolve(pea: "star"))
        XCTAssert(isSolved)
    }
    
    func testSubmarine() {
        XCTAssertNoThrow(try parseAndSolve(pea: "submarine"))
        XCTAssert(isSolved)
    }

    func testL() {
        XCTAssertNoThrow(try parseAndSolve(matrix: "L"))
        XCTAssert(isSolved)
    }
}
