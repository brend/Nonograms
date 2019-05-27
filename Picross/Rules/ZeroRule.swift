//
//  ZeroRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class ZeroRule: Rule {
    override var name: String { return "zero" }
    
    override func isApplicable(to row: [Mark], hints: [Int]) -> Bool {
        return hints == [0]
    }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard isApplicable(to: row, hints: hints) else { return row }
        
        return Array(repeating: .marked, count: row.count)
    }
}
