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
    
    var answer: Matrix?
    
    var solutionAttempt: Matrix?
    
    override func setUp() {
        puzzle = nil
        answer = nil
        solutionAttempt = nil
    }
    
    override func tearDown() {
        puzzle = nil
        answer = nil
        solutionAttempt = nil
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
        
        guard let steps = puzzle!.solve() else { return }
        
        let matrix = Matrix(size: puzzle!.size)
        
        solutionAttempt = SolutionStep.apply(steps: steps, to: matrix)
    }
    
    func parseAndSolve(matrix filename: String) throws {
        let path = bundlePath(for: filename, filetype: "matrix")
        let matrix = try Matrix.parse(matrixFile: path)
        let (rowHints, columnHints) = HintProvider(matrix: matrix).hints()
        
        answer = matrix
        puzzle = Puzzle(rowHints: rowHints, columnHints: columnHints)
        
        solve()
    }
    
    func parseAndSolve(pea filename: String) throws {
        let path = bundlePath(for: filename, filetype: "pea")
        
        puzzle = try Puzzle.parse(peaFile: path)
        
        solve()
    }
    
    var isSolved: Bool {
        let validator = HintConsistencyValidator(puzzle!)
        
        return validator.hintsCompleteAndConsistent(with: solutionAttempt!)
    }

    func testMarioFace() {
        XCTAssertNoThrow(try parseAndSolve(matrix: "mario_face"))
        XCTAssert(isSolved)
    }

    // "boat plus" is ambiguous
//    func testBoatPlus() {
//        XCTAssertNoThrow(try parseAndSolve(matrix: "boat_plus"))
//        XCTAssert(isSolved)
//    }
    
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
