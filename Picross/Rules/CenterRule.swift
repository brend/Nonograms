//
//  CenterRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CenterRule: Rule {
    override var name: String { return "center" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard hints.count == 1 else { return row }
        
        guard let (startEmpty, endEmpty) = freeRangeClosed(row: row) else {
            return row
        }

        let hint = hints.first!
        let emptyCount = endEmpty - startEmpty + 1
        let blanks = emptyCount - hint
        let numberOfColumnsToPaint = emptyCount - 2 * blanks
        
        return chisel(row, from: startEmpty + blanks, count: numberOfColumnsToPaint)
    }
    
    func freeRangeClosed(row: [Mark]) -> (Int, Int)? {
        if let firstNonMarked = row.firstIndex(where: {$0 != .marked}),
            let lastNonMarked = row.lastIndex(where: {$0 != .marked}) {
            return (firstNonMarked, lastNonMarked)
        } else {
            return nil
        }
    }
}
