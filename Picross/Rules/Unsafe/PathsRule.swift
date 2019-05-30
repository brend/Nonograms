//
//  PathsRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

//class PathsRule: Rule {
//    func applyToPath(_ path: [Mark], hint: Int) -> [Mark] {
//        return path
//    }
//    
//    override func isApplicable(to row: [Mark], hints: [Int]) -> Bool {
//        let ps = paths(in: row)
//        
//        return ps.count == hints.count
//    }
//    
//    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
//        guard isApplicable(to: row, hints: hints) else { return row }
//        
//        let ps = paths(in: row)
//        var alteredRow = row
//        
//        for (i, h) in hints.enumerated() {
//            let p = ps[i]
//            let slice = row[p]
//            let alteration = applyToPath(Array(slice), hint: h)
//            
//            for k in p {
//                alteredRow[k] = alteration[k - p.startIndex]
//            }
//        }
//        
//        return alteredRow
//    }
//}
