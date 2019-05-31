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
    
    init(start: Int, length: Int, associatedHintIndex: Int? = nil) {
        self.start = start
        self.length = length
        self.associatedHintIndex = associatedHintIndex
    }
    
    func associate(with hintIndex: Int) -> Run {
        return Run(start: start, length: length, associatedHintIndex: hintIndex)
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
//    guard runs.count >= hints.count else { return runs }
//
//    if hints.count == 1 {
//        return runs.map { $0.associate(with: 0) }
//    }
//
//    guard let runPairs = runs.pairs() else { return runs }
//
//    // |hints| > 1, |runs| >= |hints|
//    var currentHintIndex = 0
//    var asscociations = [0: [runs[0]]]
//
//    for (r1, r2) in runPairs {
//        if r1.lengthCombined(with: r2) >
//    }
    
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
