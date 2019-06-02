//
//  CompleteReverseFlushRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

/*
 *          2 1 _x▓_xx▓ -> _x▓▓xx▓
 *
 *          1 2 ▓xx__▓x -> ▓xx_▓▓x
 *
 * If all paths up to p_i have been filled up with chisels,
 * and |p_i| <= h_i + h_(i+1),
 * then hint(p_i) = h_i
 * Goes forward and backward
 */

class CompleteReverseFlushRule: Rule {
    public override var name: String { return "Complete Reverse Flush" }
    
    override var symmetric: Bool { return false }
    
    // TODO: to be implemented
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        return row
    }
    
//    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
//        guard let firstUnknown = row.firstIndex(of: .unknown),
//            firstUnknown > 0,
//            row[firstUnknown - 1] == .chiseled
//            else {
//                return row
//        }
//
//        let rs = runsEx(row, of: .chiseled).filter {$0.start < firstUnknown}
//        let correspondingHint = hints[rs.count - 1]
//
//        return chisel(row, from: rs.last!.start, count: correspondingHint)
//    }
    
}
