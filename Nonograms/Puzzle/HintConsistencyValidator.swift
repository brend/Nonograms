//
//  HintConsistencyValidator.swift
//  Nonograms
//
//  Created by Philipp Brendel on 10.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct HintConsistencyValidator {
    let rowHints: [[Int]]
    let columnHints: [[Int]]
    
    init(_ puzzle: Puzzle) {
        self.rowHints = puzzle.rowHints
        self.columnHints = puzzle.columnHints
    }
    
    fileprivate func rowHintsCompleteAndConsistent(_ matrix: Matrix) -> Bool {
        for (rowIndex, hints) in rowHints.enumerated() {
            let row = matrix.row(rowIndex)
            
            guard hintsCompleteAndConsistent(row: row, hints: hints)
            else { return false }
        }
        
        return true
    }
    
    fileprivate func columnHintsCompleteAndConsistent(_ matrix: Matrix) -> Bool {
        for (columnIndex, hints) in columnHints.enumerated() {
            let row = matrix.column(columnIndex)
            
            guard hintsCompleteAndConsistent(row: row, hints: hints)
            else { return false }
        }
        
        return true
    }
    
    fileprivate func hintsCompleteAndConsistent(row: [Mark], hints: [Int]) -> Bool {
        let runs = runsEx(row, of: .chiseled)
        
        if hints == [0] {
            return runs.count == 0
        }
        
        let inferredHints = runs.map {$0.length}
        
        return hints == inferredHints
    }
    
    func hintsCompleteAndConsistent(with matrix: Matrix) -> Bool {
        return rowHintsCompleteAndConsistent(matrix)
            && columnHintsCompleteAndConsistent(matrix)
    }
}
