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
    
    var symmetric: Bool { return true }
    
    func applyExhaustively(to row: [Mark], hints: [Int]) -> [Mark] {
        let forwardResult = apply(to: row, hints: hints)
        
        if symmetric {
            return forwardResult
        }
        
        return applyReversed(to: forwardResult, hints: hints);
    }
    
    func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        return row
    }
    
    func applyReversed(to row: [Mark], hints: [Int]) -> [Mark] {
        let reversedAlteredRow = apply(to: row.reversed(), hints: hints.reversed())
        
        return reversedAlteredRow.reversed()
    }

    func chisel(_ row: [Mark], from index: Int, count: Int, mark: Mark = .chiseled) -> [Mark] {
        guard count >= 0 else { return row }
        
        var chiseled = row
        
        for i in index..<(index + count) {
            chiseled[i] = mark
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
    
    static var defaultSet: [Rule] {
        return [
            CenterRule(),
            ZeroRule(),
            MarkFinishedRule(),
            CompleteSingularRunsRule(),
            MarkSmallPathsRule(),
            MarkLongestHintRule(),
            SumRule(),
            MarkSingularRunRule(),
            CompleteFlushRule(),
            CompleteUnambiguousRule(),
            PerfectFitRule(),
            ShrinkRule(),
            DistanceRule(),
            CloseToLeftRule(),
            FullFirstHintRule()
        ]
    }
}
