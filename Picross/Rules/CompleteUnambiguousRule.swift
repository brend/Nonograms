//
//  CompleteUnambiguousRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CompleteUnambiguousRule: Rule {
    override var name: String { return "Complete Unambiguous" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard hints.reduce(0, +) + hints.count - 1 == row.count else {
            return row
        }
        
        var start = 0
        var alteredRow = row
        
        for h in hints {
            alteredRow = chisel(alteredRow, from: start, count: h)
            start += h + 1
        }
        
        return alteredRow
    }
}
