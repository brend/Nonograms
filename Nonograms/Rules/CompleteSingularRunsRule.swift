//
//  CompleteSingularRuns.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class CompleteSingularRunsRule: Rule {
    public override var name: String { return "Complete Singular Runs" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard hints.count == 1 else {
            return row
        }
        
        let rs = runsEx(row, of: .chiseled)
        
        guard rs.count > 1 else {
            return row
        }
        
        let first = rs.first!
        let last = rs.last!
        
        return chisel(row, from: first.start, count: last.start - first.start)
    }
}
