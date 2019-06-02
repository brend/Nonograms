//
//  Run.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

typealias Path = Range<Int>

struct Run {
    let start, length: Int
    let associatedHintIndex: Int?
    let associatedPath: Path?
    
    var nextAfter: Int { return start + length }
    
    init(start: Int, length: Int, associatedHintIndex: Int? = nil, associatedPath: Path? = nil) {
        self.start = start
        self.length = length
        self.associatedHintIndex = associatedHintIndex
        self.associatedPath = associatedPath
    }
    
    func associate(with hintIndex: Int, path: Path) -> Run {
        return Run(start: start, length: length, associatedHintIndex: hintIndex, associatedPath: path)
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
        let associatedRuns = associate(runs: runs, to: hints, row: row)
        
        return associatedRuns
    } else {
        return runs
    }
}

func associate(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    guard runs.count >= hints.count else { return runs }

    let ps = paths(in: row)
    
    // group runs by paths they occur in
    let runsGroupedByPaths =
        Dictionary(grouping: runs) {
        run -> Range<Int> in
        
        let path = ps.first(where: { path in path.contains(run.start) })
            
        return path!
    }
    
    // the number of paths with at least one run in it
    // must equal the number of hints
    guard runsGroupedByPaths.keys.count == hints.count else {
        return runs
    }
    
    // each path that has at least one run in it corresponds to exactly one hint
    let usedPaths = runsGroupedByPaths.keys.sorted(by: { $0.lowerBound < $1.lowerBound })
    var associatedRuns = [Run]()
    
    for (hintIndex, path) in usedPaths.enumerated() {
        for run in runsGroupedByPaths[path]! {
            associatedRuns.append(run.associate(with: hintIndex, path: path))
        }
    }
    
    assert(associatedRuns.count == runs.count)
    
    return associatedRuns
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
