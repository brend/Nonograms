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
    let associatedPath: Range<Int>?
    
    var nextAfter: Int { return start + length }
    
    init(start: Int, length: Int,
         associatedHintIndex: Int? = nil,
              associatedPath: Range<Int>? = nil) {
        self.start = start
        self.length = length
        self.associatedHintIndex = associatedHintIndex
        self.associatedPath = associatedPath        
    }
    
    func associate(with hintIndex: Int, path: Range<Int>) -> Run {
        assert(self.associatedHintIndex == nil || self.associatedHintIndex == hintIndex)
        assert(self.associatedPath == nil || self.associatedPath == path)
        
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
        let assocGen1 = associateGen1(runs: runs, to: hints, row: row)
        let assocGen2 = associateGen2(runs: assocGen1, to: hints, row: row)
        let assocGen3 = associateGen3(runs: assocGen2, to: hints, row: row)
        let assocGen4 = associateGen4(runs: assocGen3, to: hints, row: row)
        let assocGen5 = associateGen5(runs: assocGen4, to: hints, row: row)
        
        return assocGen5
    } else {
        return runs
    }
}

func associateGen1(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
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

func associateGen2(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    /*
    * If all paths up to p_i have been filled up with chisels,
    * and |p_i| <= h_i + h_(i+1),
    * then hint(p_i) = h_i
    * Goes forward and backward
 */
    
    var remainingRuns = runs
    var associatedRuns = [Run]()
    let ps = paths(in: row)
    var hintIndex = 0
    
    for path in ps {
        // ALSO: if it doesn't contain a chisel and is smaller than the current hint, we can skip it
        if row[path].contains(.chiseled)
            && ((hintIndex + 1 >= hints.count)
                || (path.count <= hints[hintIndex] + hints[hintIndex + 1])) {
            
            // all runs in this path are associated with hintIndex
            while let run = remainingRuns.first,
                path.contains(run.start) {
                associatedRuns.append(run.associate(with: hintIndex, path: path))
                remainingRuns.removeFirst()
            }
            
            hintIndex += 1
        } else {
            // if the first path that does not contain a chisel
            break
        }
    }
    
    associatedRuns.append(contentsOf: remainingRuns)
    
    return associatedRuns
}

/*
 * If the number of paths equals the number of hints,
 * and no two sequential hints fit in the same path,
 * the association is unique
 */
func associateGen3(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    
    guard !runs.isEmpty else { return runs }
    
    let ps = paths(in: row)
    
    guard ps.count == hints.count else {
        return runs
    }
    
    var remainingRuns = runs
    var associatedRuns = [Run]()
    
    for hintIndex in 0..<hints.count {
        let path = ps[hintIndex]
        let hint = hints[hintIndex]
        
        if hintIndex + 1 < hints.count {
            let nextHint = hints[hintIndex + 1]
            
            if hint + nextHint < path.count {
                return runs
            }
        }
        
        if hintIndex > 0 {
            let previousHint = hints[hintIndex - 1]

            if hint + previousHint < path.count {
                return runs
            }
        }
        
        while let run = remainingRuns.first,
            path.contains(run.start) {
            associatedRuns.append(run.associate(with: hintIndex, path: path))
            remainingRuns.removeFirst()
        }
    }
    
    associatedRuns.append(contentsOf: remainingRuns)
    
    return associatedRuns
}

func associateGen4(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    guard let longestHint = hints.max(),
        let secondLongestHint = hints.filter({$0 < longestHint}).max(),
        let incompleteRun = runs.first(where: {$0.length > secondLongestHint
                                            && $0.length < longestHint})
    else { return runs }
    

    // associate with hint length, but not index?
    // can't know the index if multiple max length
    
    // HACK: only do this if longest hint is unique
    guard let firstLongestHintIndex = hints.firstIndex(of: longestHint),
        let lastLongestHintIndex = hints.lastIndex(of: longestHint),
        firstLongestHintIndex == lastLongestHintIndex
    else { return runs }
    
    var associatedRuns = [Run]()
    
    let paths = pathsEx(row, hints: hints)
    
    for run in runs {
        if run.start == incompleteRun.start {
            let path = paths.first(where: {$0.contains(run.start)})!
            let associatedRun =
                incompleteRun.associate(with: firstLongestHintIndex, path: path.range)
            
            associatedRuns.append(associatedRun)
        } else {
            associatedRuns.append(run)
        }
    }
    
    return associatedRuns
}

func associateGen5(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    
    var associatedRuns = [Run]()
    var hintIndex = 0
    var remainingRuns = runs
    
    let paths = pathsEx(row, hints: hints)
    
    while !remainingRuns.isEmpty {
        let run = remainingRuns.removeFirst()
        let hint = hints[hintIndex]
        
        guard run.length == hint
            && !row.prefix(upTo: run.start).contains(.unknown)
        else {
            associatedRuns.append(run)
            break
        }
        
        let path = paths.first(where: {$0.contains(run.start)})!
        
        associatedRuns.append(run.associate(with: hintIndex, path: path.range))
        hintIndex += 1
    }
    
    associatedRuns.append(contentsOf: remainingRuns)
    
    // and backwards
    remainingRuns = associatedRuns
    associatedRuns = []
    hintIndex = hints.count - 1
    
    while !remainingRuns.isEmpty {
        let run = remainingRuns.removeLast()
        let hint = hints[hintIndex]
        
        guard run.length == hint
            && !row.suffix(row.count - run.nextAfter).contains(.unknown)
        else {
            associatedRuns.append(run)
            break
        }
        
        let path = paths.first(where: {$0.contains(run.start)})!
        
        associatedRuns.append(run.associate(with: hintIndex, path: path.range))
        hintIndex -= 1
    }
    
    associatedRuns.append(contentsOf: remainingRuns.reversed())
    
    return associatedRuns.reversed()
}

