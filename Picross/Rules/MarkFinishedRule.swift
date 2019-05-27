//
//  MarkFinishedRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class MarkFinishedRule: Rule {
    override var name: String { return "mark finished" }
    
    override func isApplicable(to row: [Mark], hints: [Int]) -> Bool {
        return finished(row, hints: hints)
    }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard isApplicable(to: row, hints: hints) else { return row }
        
        var filled = row
        
        for (i, m) in row.enumerated() {
            filled[i] = (m == .unknown) ? .marked : m
        }
        
        return filled
    }
}
