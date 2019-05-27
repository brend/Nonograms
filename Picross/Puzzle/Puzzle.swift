//
//  Puzzle.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class Puzzle {
    let solution: Matrix
    
    let userRowHints: [[Int]]?
    let userColumnHints: [[Int]]?
    
    init(solution: Matrix) {
        self.solution = solution
        self.userRowHints = nil
        self.userColumnHints = nil
    }
    
    init(rowHints: [[Int]], columnHints: [[Int]]) {
        guard rowHints.count == columnHints.count && rowHints.count > 0 else {
            fatalError()
        }
        
        self.solution = Matrix(size: rowHints.count)
        self.userRowHints = rowHints
        self.userColumnHints = columnHints
    }
    
    var rules = [
        CenterRule(),
        ZeroRule(),
        MarkFinishedRule(),
        MatchPathsRule(),
        PadPathsRule(),
        PathCompleteRule()
    ]
    
    func solve() {
        if self.userRowHints == nil {
            print("this is the solution:")
            solution.printMatrix()
        }
        
        var before = Matrix(size: size)
        
        print("\nbeginning to solve...")
        before.printMatrix()
        
        repeat {
            var after = before
            
            for rule in rules {
                for i in 0..<after.size {
                    let rowBefore = after.row(i)
                    let hints = rowHints(i)
                    
                    guard rule.isApplicable(to: rowBefore, hints: hints) else {
                        continue
                    }
                    
                    let rowAfter = rule.apply(to: rowBefore, hints: hints)
                    let afterBeforeIntegration = after
                    
                    after.integrate(row: rowAfter, at: i)
                    
                    guard solution.isConsistent(with: after) else {
                        fatalError("rule application leads to inconsistency with solution")
                    }
                    
                    if afterBeforeIntegration != after {
                        print("\nrule \(rule.name), row \(i)")
                        after.printMatrix()
                    }
                }
                
                for i in 0..<after.size {
                    let columnBefore = after.column(i)
                    let hints = columnHints(i)
                    
                    guard rule.isApplicable(to: columnBefore, hints: hints) else {
                        continue
                    }
                    
                    let columnAfter = rule.apply(to: columnBefore, hints: hints)
                    let afterBeforeIntegration = after
                    
                    after.integrate(column: columnAfter, at: i)
                    
                    guard solution.isConsistent(with: after) else {
                        fatalError("rule application leads to inconsistency with solution")
                    }
                    
                    if afterBeforeIntegration != after {
                        print("\nrule \(rule.name), column \(i)")
                        after.printMatrix()
                    }
                }
            }
            
            //            print()
            //            after.printMatrix()
            
            if after == before {
                break
            }
            
            before = after
        } while true
    }
    
    func rowHints(_ rowIndex: Int) -> [Int] {
        
        if let userRowHints = userRowHints {
            return userRowHints[rowIndex]
        }
        
        var hints = [Int]()
        var run = 0
        
        for mark in solution.row(rowIndex) {
            switch mark {
            case .chiseled:
                run += 1
            case .unknown:
                hints.append(run)
                run = 0
            default:
                fatalError()
            }
        }
        
        hints.append(run)
        
        return hints.filter {$0 != 0}
    }
    
    func columnHints(_ columnIndex: Int) -> [Int] {
        
        if let userColumnHints = userColumnHints {
            return userColumnHints[columnIndex]
        }
        
        var hints = [Int]()
        var run = 0
        
        for mark in solution.column(columnIndex) {
            switch mark {
            case .chiseled:
                run += 1
            case .unknown:
                hints.append(run)
                run = 0
            default:
                fatalError()
            }
        }
        
        hints.append(run)
        
        let withoutZeroes = hints.filter {$0 != 0}
        
        return withoutZeroes.count > 0 ? withoutZeroes : [0]
    }
    
    var size: Int { return solution.size }
}
