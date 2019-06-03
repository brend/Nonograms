//
//  PerfectFitRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

//public class PerfectFitRule: Rule {
//    public override var name: String { return "Perfect Fit" }
//    
//    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
//        let paths = pathsEx(row)
//        
//        guard paths.count == 1,
//            let path = paths.first,
//            path.length == minimalLength(hints: hints)
//        else {
//            return row
//        }
//        
//        var start = path.start
//        var alteredRow = row
//        
//        for h in hints {
//            alteredRow = chisel(alteredRow, from: start, count: h)
//            start += h + 1
//        }
//        
//        return alteredRow
//    }
//}
