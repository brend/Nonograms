//
//  MarkSingularRunRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class MarkSingularRunRule: Rule {
    public override var name: String { return "Mark Singular Run" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard hints.count == 1 else {
            return row
        }
        
        let rs = runsEx(row, of: .chiseled)
        
        guard let leftAnchor = rs.first?.start,
            let rightAnchor = rs.last?.nextAfter
        else {
            return row
        }
        
        let confirmedLength = rightAnchor - leftAnchor
        
        guard confirmedLength <= hints.first! else {
            fatalError("chiseled boxes inconsistent with hint")
        }
        
        let blanks = hints.first! - confirmedLength
        var alteredRow = row
        
        for i in 0..<row.count {
            if i < leftAnchor - blanks
                || i >= rightAnchor + blanks {
                alteredRow[i] = .marked
            }
        }
        
        return alteredRow
    }
}
