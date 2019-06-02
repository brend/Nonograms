//
//  FullFirstHint.swift
//  Picross
//
//  Created by Philipp Brendel on 31.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class FullFirstHintRule: Rule {
    public override var name: String { return "Full First Hint" }
    
    override var symmetric: Bool { return false }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let h = hints.first,
            let r = runsEx(row, of: .chiseled).first,
            r.start <= h,
            r.length == h
        else { return row }
        
        var alteredRow = row
        
        alteredRow = chisel(alteredRow, from: 0, count: r.start, mark: .marked)
        
        if r.nextAfter < row.count {
            alteredRow = chisel(alteredRow, from: r.nextAfter, count: 1, mark: .marked)
        }
        
        return alteredRow
    }
}
