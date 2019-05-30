//
//  SingleFitRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

//class SingleFitRule: Rule {
//    override var name: String { return "Single Fit" }
//    
//    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
//        var possibleFits = Int[]()
//        
//        for start in 0..<row.count {
//            
//        }
//        
//        guard possibleFits.count == 1 else {
//            return row
//        }
//        
//        var start = possibleFits.first!
//        var alteredRow = row
//        
//        for h in hints {
//            alteredRow = chisel(alteredRow, from: start, count: h)
//            start += h + 1
//            
//            while start < row.count && alteredRow[start] == .marked {
//                start += 1
//            }
//        }
//        
//        return alteredRow
//    }
//}
