//
//  CloseUnusablePathsRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CloseUnusablePathsRule: Rule {
    override var name: String { return "Close Smallest Unassociated Path" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let runs = runsEx(row, of: .chiseled, hints: hints)
        let associatedIndices = runs.map {$0.associatedHintIndex}
        let unassociatedIndices =
            (0..<hints.count)
                .filter({!associatedIndices.contains($0)})
                .sorted()
        let emptyPaths = emptyPathsEx(row, hints: hints)
        let placements =
            findAllPlacements(hints: hints,
                              hintIndicesToDistribute: unassociatedIndices,
                              emptyPaths: emptyPaths)
        
        // close all paths that do not occur in any placement
        var alteredRow = row
        let pathsOccurringInPlacements = placements.map({$0.map({$0.path})}).joined()
        let pathsThatDontOccurInAnyPlacement =
            emptyPaths.filter({!pathsOccurringInPlacements.contains($0)})
        
        for path in pathsThatDontOccurInAnyPlacement {
            alteredRow = chisel(alteredRow, from: path.start, count: path.length, mark: .marked)
        }
        
        return alteredRow
    }
}
