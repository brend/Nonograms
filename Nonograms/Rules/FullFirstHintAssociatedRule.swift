//
//  FullFirstHintAssociatedRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 07.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class FullFirstHintAssociatedRule: Rule {
    override var name: String { return "Full First Hint Associated" }
    
    let fullFirstHintRule = FullFirstHintRule()
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let runs = runsEx(row, of: .chiseled, hints: hints)
        
        var alteredRow = row
        
        for run in runs {
            guard let hintIndex = run.associatedHintIndex,
                let path = run.associatedPath
                else { continue }
            
            let runData = Array(row[path])
            let alteredData = fullFirstHintRule.apply(to: runData, hints: [hints[hintIndex]])
            
            for (i, mark) in alteredData.enumerated() {
                alteredRow[path.lowerBound + i] = mark
            }
        }
        
        return alteredRow
    }
}
