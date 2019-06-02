//
//  CloseUnassociatedPathsRule.swift
//  Picross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CloseUnassociatedPathsRule: Rule {
    override var name: String { return "Close Unassociated Paths" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let runs = runsEx(row, of: .chiseled, hints: hints)
        
        guard !runs.isEmpty else { return row }
        
        let associatedPaths = runs.map {$0.associatedPath}
        
        guard !associatedPaths.contains(nil) else { return row }
        
        var alteredRow = row
        
        for path in paths(in: row) {
            if !associatedPaths.contains(path) {
                alteredRow = chisel(alteredRow, from: path.lowerBound, count: path.count, mark: .marked)
            }
        }
        
        return alteredRow
    }
}
