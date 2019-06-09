//
//  CenterUniqueEmptyPathsRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CenterUniqueEmptyPathsRule: Rule {
    let centerRule = CenterRule()
    
    override var name: String { return "Center Unique Empty Paths" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let emptyPaths = emptyPathsEx(row, hints: hints)
        let runs = runsEx(row, of: .chiseled, hints: hints)
        let associatedIndices = runs.map {$0.associatedHintIndex}
        let unassociatedIndices =
            (0..<hints.count)
                .filter({!associatedIndices.contains($0)})
                .sorted()
        let placements = findAllPlacements(hints: hints,
                                           hintIndicesToDistribute: unassociatedIndices,
                                           emptyPaths: emptyPaths)
        
        // find indices with unique placement
        let uniquePlacements =
            Dictionary(grouping: placements.joined(),
                       by: {$0.hintIndex})
            .filter({hintIndex, possiblePlacements in possiblePlacements.count == 1})
        var alteredRow = row
        
        for (hintIndex, possiblePlacements) in uniquePlacements {
            let placement = possiblePlacements.first!
            let path = placement.path
            let slice = Array(row[path.range])
            let result = centerRule.apply(to: slice, hints: [hints[hintIndex]])
            
            for i in path.start..<path.nextAfter {
                alteredRow[i] = result[i - path.start]
            }
        }
        
        return alteredRow
    }
}
