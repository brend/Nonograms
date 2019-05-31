//
//  Run.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct Run {
    let start, length: Int
    let associatedHintIndex: Int?
    
    var nextAfter: Int { return start + length }
    
    init(start: Int, length: Int) {
        self.start = start
        self.length = length
        self.associatedHintIndex = nil
    }
}

func runsEx(_ row: [Mark], of mark: Mark, hints: [Int]? = nil) -> [Run] {
    var runs = [Run]()
    var index = 0
    var currentRunLength = 0
    
    for i in 0..<row.count {
        if row[i] == mark {
            currentRunLength += 1
        } else if currentRunLength > 0 {
            runs.append(Run(start: i - currentRunLength, length: currentRunLength))
            currentRunLength = 0
            index += 1
        }
    }
    
    if currentRunLength > 0 {
        runs.append(Run(start: row.count - currentRunLength, length: currentRunLength))
    }
    
    if let hints = hints {
        let associatedRuns = associate(runs: runs, to: hints)
        
        return associatedRuns
    } else {
        return runs
    }
}

func associate(runs: [Run], to hints: [Int]) -> [Run] {
    return runs
}

func pathsEx(_ row: [Mark]) -> [Run] {
    var runs = [Run]()
    var index = 0
    var currentRunLength = 0
    
    for i in 0..<row.count {
        if row[i] != .marked {
            currentRunLength += 1
        } else if currentRunLength > 0 {
            runs.append(Run(start: i - currentRunLength, length: currentRunLength))
            currentRunLength = 0
            index += 1
        }
    }
    
    if currentRunLength > 0 {
        runs.append(Run(start: row.count - currentRunLength, length: currentRunLength))
    }
    
    return runs
}
