//
//  MarkFinishedRunRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 15.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class MarkFinishedRunRule: Rule {
    
    override var name: String { return "Mark Finished Run" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let runs = runsEx(row, of: .chiseled, hints: hints)
        var alteredRow = row
        
        for run in runs {
            guard let hintIndex = run.associatedHintIndex,
                run.length == hints[hintIndex]
                else { continue }
            
            if run.start > 0 {
                alteredRow = chisel(alteredRow, from: run.start - 1, count: 1, mark: .marked)
            }
            
            if run.nextAfter < alteredRow.count {
                alteredRow = chisel(alteredRow, from: run.nextAfter, count: 1, mark: .marked)
            }
        }
        
        return alteredRow
    }
    
}
