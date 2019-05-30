//
//  CompleteFlushRightRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CompleteFlushRightRule: Rule {
    override var name: String { return "Complete Flush Right" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard row.last == .chiseled,
            let h = hints.last else {
            return row
        }
        
        return chisel(row, from: row.count - h, count: h)
    }
}
