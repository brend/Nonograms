//
//  ShrinkAssociated.swift
//  Picross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class ShrinkAssociatedRule: Rule {    
    public override var name: String { return "Shrink Associated" }
    
    let shrinkRule = ShrinkRule()
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let runs = runsEx(row, of: .chiseled, hints: hints)
        
        var alteredRow = row
        
        for run in runs {
            guard let hintIndex = run.associatedHintIndex,
                let path = run.associatedPath
            else { continue }
            
            let runData = Array(row[path])
            let alteredData = shrinkRule.apply(to: runData, hints: [hints[hintIndex]])
            
            for (i, mark) in alteredData.enumerated() {
                alteredRow[path.lowerBound + i] = mark
            }
        }
        
        for path in pathsEx(row, hints: hints) {
            guard let hintIndex = path.associatedHintIndex
            else { continue }
            
            let runData = path.slice(row)
            let alteredData = shrinkRule.apply(to: runData, hints: [hints[hintIndex]])
            
            for (i, mark) in alteredData.enumerated() {
                alteredRow[path.start + i] = mark
            }
        }
        
        return alteredRow
    }
}
