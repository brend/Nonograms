//
//  DistanceRule.swift
//  Picross
//
//  Created by Philipp Brendel on 31.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

extension Array {
    func pairs() -> [(Element, Element)]? {
        
        guard self.count > 1 else { return nil }
        
        var result = [(Element, Element)]()
        
        for i in 1..<self.count {
            result.append((self[i - 1], self[i]))
        }
        
        return result
    }
}

class DistanceRule: Rule {
    override var name: String { return "Distance" }
    
    override var symmetric: Bool { return false }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        let rs = runsEx(row, of: .chiseled)
        
        guard rs.count == hints.count,
            rs.count > 1, // TODO: can we use this rule to x out the borders in case |hints| = 1 as well, thus making another rule obsolete? Maybe be inserting fictional runs at -1 and count?
            let H = hints.max(),
            let runPairs = rs.pairs()
        else { return row }
        
        var alteredRow = row
        
        for (r1, r2) in runPairs {
            let L = r1.start
            let R = r2.nextAfter
            
            // each successive pair of runs must be longer combined than the max hint
            // else the whole rule is not applicable
            guard R - L > H else { return row }
            
            let markStart = L + H
            let markEnd = R - H
            
            alteredRow = chisel(alteredRow, from: markStart, count: markEnd - markStart, mark: .marked)
        }
        
        // special case: first run
        // note: last run will be computed in the reversed run
        let L0 = rs[0].start - (H - rs[0].length)
        
        if L0 > 0 {
            alteredRow = chisel(alteredRow, from: 0, count: L0, mark: .marked)
        }
        
        return alteredRow
    }
}
