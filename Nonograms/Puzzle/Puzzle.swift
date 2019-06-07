//
//  Puzzle.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class Puzzle {
    public var solution: Matrix
    
    public let userRowHints: [[Int]]?
    public let userColumnHints: [[Int]]?
    
    public init(solution: Matrix) {
        self.solution = solution
        self.userRowHints = nil
        self.userColumnHints = nil
    }
    
    public init(rowHints: [[Int]], columnHints: [[Int]]) {
        guard rowHints.count == columnHints.count && rowHints.count > 0 else {
            fatalError()
        }
        
        self.solution = Matrix(size: rowHints.count)
        self.userRowHints = rowHints
        self.userColumnHints = columnHints
    }
    
    public static var demo: Puzzle {
        let puzzle =
            Puzzle.parse(file: "/Users/waldrumpus/Downloads/submarine.pea")
        
        puzzle.rules = Rule.defaultSet
        
        return puzzle
    }
    
    public func mark(rowIndex: Int, columnIndex: Int) -> Mark {
        guard rowIndex >= 0 && rowIndex < size
            && columnIndex >= 0 && columnIndex < size else {
            fatalError("invalid access \(rowIndex), \(columnIndex)")
        }
        
        return solution[rowIndex, columnIndex]
    }
    
    public func set(mark: Mark, rowIndex: Int, columnIndex: Int) {
        guard rowIndex >= 0 && rowIndex < size
            && columnIndex >= 0 && columnIndex < size else {
                fatalError("invalid access \(rowIndex), \(columnIndex)")
        }
        
        solution[rowIndex, columnIndex] = mark
    }
    
    public var rules = [Rule]()
    
    func rowsAndColumns(of matrix: Matrix) -> [Integratable] {
        var rowsAndColumns = [Integratable]()
        
        for i in 0..<matrix.size {
            rowsAndColumns.append(RowIntegratable(rowIndex: i))
            rowsAndColumns.append(ColumnIntegratable(columnIndex: i))
        }
        
        return rowsAndColumns
    }
    
    public func solve() -> [SolutionStep]? {
        if self.userRowHints == nil {
            print("this is the solution:")
            solution.printMatrix()
        }
        
        if rules.isEmpty {
            print("ruleset is empty")
            return nil
        }
        
        var steps = [SolutionStep]()
        var before = Matrix(size: size)
        
        print("\nbeginning to solve...")
        before.printMatrix()
        
        repeat {
            var after = before
            
            applyRules(to: &after, before: before) {
                step in steps.append(step)
            }
            
            if after == before {
                break
            }
            
            before = after
        } while true
        
        // DEBUG
//        let rule = ShrinkAssociatedRule()
//        let debug = rule.apply(to: before.row(14), hints: rowHints(14))
        
        return steps
    }
    
    func applyRules(to after: inout Matrix, before: Matrix, foundStep: (SolutionStep) -> ()) {
        for rule in rules {
            for data in rowsAndColumns(of: before) {
                let rowBefore = data.data(from: after)
                let hints = data.hints(self)
                let rowAfter = rule.applyExhaustively(to: rowBefore, hints: hints)
                
                if rowBefore == rowAfter {
                    continue
                }
                
                let afterBeforeIntegration = after
                
                data.integrate(data: rowAfter, into: &after)
                
                guard self.solutionIsConsistent(with: after) else {
                    fatalError("rule application leads to inconsistency with solution")
                }
                
                guard hintsAreConsistent(with: after) else {
                    fatalError("rule application leads to hint violation")
                }
                
                if afterBeforeIntegration != after {
                    print("\nrule \(rule.name), \(data)")
                    after.printMatrix()
                    
                    let step = SolutionStep(row: data, before: rowBefore, after: rowAfter, rule: rule)
                    
                    foundStep(step)
                }
            }
        }
    }
    
    func arrayHints(row: [Mark]) -> [Int] {
        var hints = [Int]()
        var run = 0
        
        for mark in row {
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
    
    public func rowHints(_ rowIndex: Int) -> [Int] {
        if let userRowHints = userRowHints {
            return userRowHints[rowIndex]
        }
        
        return arrayHints(row: solution.row(rowIndex))
    }
    
    public func columnHints(_ columnIndex: Int) -> [Int] {
        if let userColumnHints = userColumnHints {
            return userColumnHints[columnIndex]
        }
        
        return arrayHints(row: solution.column(columnIndex))
    }
    
    public var size: Int { return solution.size }
    
    func hintsAreConsistent(with matrix: Matrix) -> Bool {
        for i in 0..<size {
            let rHints = rowHints(i)
            let row = matrix.row(i)
            
            guard hints(rHints, areConsistentWith: row) else {
                return false
            }
            
            let cHints = columnHints(i)
            let column = matrix.column(i)
            
            guard hints(cHints, areConsistentWith: column) else {
                return false
            }
        }
        
        return true
    }
    
    func hints(_ hints: [Int], areConsistentWith row: [Mark]) -> Bool {
        // TODO: Implement this
        return true
    }
    
    public func toPeaFile() -> String {
        var text = ""
        
        text.append("solution\n")
        text.append(solution.renderMatrix())
        
        text.append("rows\n")
        for rowIndex in 0..<size {
            let rh = rowHints(rowIndex).map {String($0)}.joined(separator: ",")
            text.append(rh + "\n")
        }
        
        text.append("columns\n")
        for columnIndex in 0..<size {
            let ch = columnHints(columnIndex).map {String($0)}.joined(separator: ",")
            text.append(ch + "\n")
        }
        
        
        return text
    }
    
    func solutionIsConsistent(with matrix: Matrix) -> Bool {
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
