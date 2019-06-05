//
//  SumWithSpacesRule.swift
//  Nonograms
//
//  Created by Philipp Brendel on 05.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation


public class SumWithSpacesRule: Rule {
    public override var name: String { return "Sum With Spaces" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        var alteredRow = row
        var hintIndex = 0
        
        for i in 0..<alteredRow.count {
            let mark = alteredRow[i]
            
            switch mark {
            case .chiseled:
                continue
            case .marked:
                continue
            case .unknown:
                alteredRow[i] = .chiseled
            }
            
            if runLength(alteredRow, anIndex: i, hint: hints[hintIndex]) == hints[hintIndex] {
                if i + 1 < row.count {
                    alteredRow[i + 1] = .marked
                }
                
                hintIndex += 1
            }
        }
        
        return alteredRow
    }
    
    func runLength(_ row: [Mark], anIndex: Int, hint: Int) -> Int {
        guard row[anIndex] == .chiseled else { return 0 }
        
        var startIndex = anIndex
        var endIndex = anIndex
        
        while startIndex > 0 && row[startIndex - 1] == .chiseled {
            startIndex -= 1
        }
        
        while endIndex + 1 < row.count && row[endIndex + 1] == .chiseled {
            endIndex += 1
        }
        
        return endIndex - startIndex + 1
    }
}
