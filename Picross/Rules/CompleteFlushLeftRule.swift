//
//  CompleteFlushLeftRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CompleteFlushLeftRule: Rule {
    override var name: String { return "Complete Flush Left" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let firstNonMarkedIndex = row.firstIndex(where: {$0 != .marked}),
            row[firstNonMarkedIndex] == .chiseled,
            let h = hints.first else {
            return row
        }
        
        return chisel(row, from: firstNonMarkedIndex, count: h)
    }
}
