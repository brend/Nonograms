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
        var hintIndex = 0
        var alteredRow = row
        var currentRunLength = 0
        
        for i in 0..<alteredRow.count {
            guard hintIndex < hints.count else { break }
            
            let mark = alteredRow[i]
            let currentHint = hints[hintIndex]
            
            switch mark {
            case .chiseled, .unknown:
                alteredRow[i] = .chiseled
                currentRunLength += 1
                
                if currentRunLength == currentHint {
                    if i + 1 < alteredRow.count {
                        guard row[i + 1] != .chiseled else { return row }
                        
                        // don't overwrite an actual mark
                        if row[i + 1] == .unknown {
                            alteredRow[i + 1] = .hypotheticalMark
                        }
                    }
                    
                    hintIndex += 1
                    currentRunLength = 0
                }
                
            case .marked, .hypotheticalMark:
                currentRunLength = 0
            }
        }
        
        if hintIndex < hints.count {
            return row
        }
        
        if alteredRow.contains(.unknown) {
            return row
        }
        
        for i in 0..<(alteredRow.count - 1) {
            guard alteredRow[i...(i+1)] != [.hypotheticalMark, .marked]
            else { return row }
        }
        
        if let lastMark = alteredRow.last,
            lastMark == .hypotheticalMark {
            return row
        }
        
        guard alteredRow.filter({$0 == .chiseled}).count == hints.reduce(0, +)
        else { return row }
        
        alteredRow.replace(.hypotheticalMark, with: .marked)
        
        return alteredRow
    }
}
