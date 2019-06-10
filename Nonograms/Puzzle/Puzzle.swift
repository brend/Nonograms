//
//  Puzzle.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class Puzzle {
    public let rowHints: [[Int]]
    public let columnHints: [[Int]]
    
    public init(rowHints: [[Int]], columnHints: [[Int]]) {
        guard rowHints.count == columnHints.count && rowHints.count > 0 else {
            fatalError()
        }
        
        self.rowHints = rowHints
        self.columnHints = columnHints
        self.rules = Rule.defaultSet
    }
    
    public var rules = [Rule]()
    
    var printSteps = true
    
    var attempt: Matrix?
    
    public func solve(solution: Matrix? = nil) -> [SolutionStep]? {
        if printSteps && solution != nil {
            print("this is the solution:")
            solution?.printMatrix()
        }
        
        if printSteps && rules.isEmpty {
            print("ruleset is empty")
            return nil
        }
        
        var steps = [SolutionStep]()
        var before = Matrix(size: size)
        
        if printSteps {
            print("\nbeginning to solve...")
            before.printMatrix()
        }
        
        repeat {
            var after = before
            
            applyRules(to: &after, before: before, solution: solution) {
                step in steps.append(step)
            }
            
            if after == before {
                break
            }
            
            before = after
        } while true
        
        attempt = before
        
        return steps
    }
        
    func applyRules(to after: inout Matrix,
                      before: Matrix,
                    solution: Matrix?,
                   foundStep: (SolutionStep) -> ()) {
        for rule in rules {
            for data in before.rowsAndColumns() {
                let rowBefore = data.data(from: after)
                let hints = data.hints(self)
                let rowAfter = rule.applyExhaustively(to: rowBefore, hints: hints)
                
                if rowBefore == rowAfter {
                    continue
                }
                
                let afterBeforeIntegration = after
                
                data.integrate(data: rowAfter, into: &after)
                
                if let solution = solution {
                    guard consistent(solution: solution, with: after) else {
                        fatalError("rule application leads to inconsistency with solution")
                    }
                }
                
//                guard hintsAreConsistent(with: after) else {
//                    fatalError("rule application leads to hint violation")
//                }
                
                if afterBeforeIntegration != after {
                    
                    if printSteps {
                        print("\nrule \(rule.name), \(data)")
                        after.printMatrix()
                    }
                    
                    let step = SolutionStep(row: data, before: rowBefore, after: rowAfter, rule: rule)
                    
                    foundStep(step)
                }
            }
        }
    }
    
    public func rowHints(_ rowIndex: Int) -> [Int] {
        return rowHints[rowIndex]
    }
    
    public func columnHints(_ columnIndex: Int) -> [Int] {
        return columnHints[columnIndex]
    }
    
    public var size: Int { return rowHints.count }
    
//    public func toPeaFile() -> String {
//        var text = ""
//
//        text.append("solution\n")
//        text.append(solution.renderMatrix())
//
//        text.append("rows\n")
//        for rowIndex in 0..<size {
//            let rh = rowHints(rowIndex).map {String($0)}.joined(separator: ",")
//            text.append(rh + "\n")
//        }
//
//        text.append("columns\n")
//        for columnIndex in 0..<size {
//            let ch = columnHints(columnIndex).map {String($0)}.joined(separator: ",")
//            text.append(ch + "\n")
//        }
//
//
//        return text
//    }
    
    func consistent(solution: Matrix, with matrix: Matrix) -> Bool {
        for rowIndex in 0..<size {
            for columnIndex in 0..<size {
                switch (matrix[rowIndex, columnIndex], solution[rowIndex, columnIndex]) {
                case (.chiseled, .unknown):
                    fatalError()
                case (.marked, .chiseled):
                    fatalError()
                default:
                    break
                }
            }
        }

        return true
    }
}
