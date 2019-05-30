//
//  MarkLongestHintRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class MarkLongestHintRule: Rule {
    override var name: String { return "Mark Longest Hint" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let longestHint = hints.max() else {
            return row
        }
        
        let rs = runsEx(row, of: .chiseled)
        var alteredRow = row
        
        for run in rs.filter({$0.length == longestHint}) {
            if run.start > 0 {
                alteredRow[run.start - 1] = .marked
            }
            
            if run.nextAfter < row.count {
                alteredRow[run.nextAfter] = .marked
            }
        }
        
        return alteredRow
    }
}
