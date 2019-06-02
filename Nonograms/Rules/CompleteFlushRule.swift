//
//  CompleteFlushRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class CompleteFlushRule: Rule {
    public override var name: String { return "Complete Flush" }
    
    override var symmetric: Bool { return false }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let firstUnknown = row.firstIndex(of: .unknown),
            firstUnknown > 0,
            row[firstUnknown - 1] == .chiseled
        else {
            return row
        }
        
        let rs = runsEx(row, of: .chiseled).filter {$0.start < firstUnknown}
        let correspondingHint = hints[rs.count - 1]
        
        return chisel(row, from: rs.last!.start, count: correspondingHint)
    }
    
}
