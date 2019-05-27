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
    
    override func isApplicable(to row: [Mark], hints: [Int]) -> Bool {
        let hint = hints.first!
        let blanks = row.count - hint
        let numberOfColumnsToPaint = row.count - 2 * blanks
        
        return hints.count == 1 && numberOfColumnsToPaint > 0
    }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard isApplicable(to: row, hints: hints) else { return row }
        
        let hint = hints.first!
        let blanks = row.count - hint
        let numberOfColumnsToPaint = row.count - 2 * blanks
        
        return chisel(row, from: blanks, count: numberOfColumnsToPaint)
    }
}
