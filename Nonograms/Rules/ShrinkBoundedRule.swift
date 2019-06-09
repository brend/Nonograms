//
//  ShrinkBoundedRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 09.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class ShrinkBoundedRule: Rule {
    let shrinkRule = ShrinkRule()
    
    override var name: String { return "Shrink Bounded" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard
            let leftBound = row.firstIndex(where: {$0 != .marked}),
            let rightBound = row.lastIndex(where: {$0 != .marked})
        else { return row }
        
        let boundedRow = Array(row[leftBound...rightBound])
        let alteredBoundedRow = shrinkRule.apply(to: boundedRow, hints: hints)
        let alteredRow =
            Array(row.prefix(leftBound)
                + alteredBoundedRow
                + row.suffix(row.count - (rightBound + 1)))
        
        return alteredRow
    }
}
