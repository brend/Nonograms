//
//  MarkSmallPaths.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public class MarkSmallPathsRule: Rule {
    public override var name: String { return "Mark Small Paths" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let smallestHint = hints.min() else {
            return row
        }
        
        let rs = runsEx(row, of: .unknown)
        var alteredRow = row
        
        for run in rs.filter({$0.length < smallestHint}) {
            if surrounded(alteredRow, run, .marked) {
                alteredRow = chisel(row, from: run.start, count: run.length, mark: .marked)
            }
        }
        
        for path in pathsEx(row, hints: hints) {
            if path.length < smallestHint {
                alteredRow = chisel(row, from: path.start, count: path.length, mark: .marked)
            }
        }
        
        return alteredRow
    }
}

func surrounded(_ row: [Mark], _ run: Run, _ mark: Mark) -> Bool {
    guard run.start > 0 && run.start + run.length < row.count else {
        return false
    }
    
    return row[run.start - 1] == mark
        && row[run.start + run.length] == mark
}
