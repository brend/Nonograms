//
//  SumRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class SumRule: Rule {
    public override var name: String { return "Sum" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let spaceCount = row.filter {$0 != .marked}.count
        let hintCount = hints.reduce(0, +)
        
        guard spaceCount == hintCount else {
            return row
        }
        
        return row.map {$0 == .unknown ? .chiseled : $0}
    }
}
