//
//  CloseToLeftAssociated.swift
//  Nonograms
//
//  Created by Philipp Brendel on 08.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class CloseToLeftAssociatedRule: Rule {
    public override var name: String { return "Close to Left Associated" }
    
    override var symmetric: Bool { return false }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        
        let runs = runsEx(row, of: .chiseled, hints: hints)
        let paths = pathsEx(row, hints: hints)
        var alteredRow = row
        
        for run in runs {
            guard let hintIndex = run.associatedHintIndex else { continue }
            
            let h = hints[hintIndex]
            let path = paths.first(where: {$0.contains(run.start)})!
            
            if run.start - path.start < h - 1 {
                alteredRow = chisel(alteredRow, from: run.start, count: h - (run.start - path.start))
            }
        }
        
        return alteredRow
    }
}
