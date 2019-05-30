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
        guard row.first == .chiseled,
            let h = hints.first else {
            return row
        }
        
        return chisel(row, from: 0, count: h)
    }
}
