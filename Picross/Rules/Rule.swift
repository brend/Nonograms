//
//  Rule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class Rule {
    var name: String { return "unnamed" }
    
    func isApplicable(to row: [Mark], hints: [Int]) -> Bool {
        return true
    }
    
    func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        return row
    }
    
    func chisel(_ row: [Mark], from index: Int, count: Int) -> [Mark] {
        guard count >= 0 else { return row }
        
        var chiseled = row
        
        for i in index..<(index + count) {
            chiseled[i] = .chiseled
        }
        
        return chiseled
    }
    
    func finished(_ row: [Mark], hints: [Int]) -> Bool {
        let r = runs(row, of: .chiseled)
        
        return r == hints
    }
    
    func runs(_ row: [Mark], of mark: Mark) -> [Int] {
        var run = 0
        var runs = [Int]()
        
        for m in row {
            if m == mark {
                run += 1
            } else {
                runs.append(run)
                run = 0
            }
        }
        
        runs.append(run)
        
        return runs.filter {$0 > 0}
    }
}
