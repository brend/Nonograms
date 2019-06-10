//
//  Run.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct Run: Equatable {
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
    
    // DEBUG
//    if row == Mark.parse("|x|_|▓|_|_|▓|▓|x|▓|▓|_|_|▓|_|x|") && hints == [1, 3, 3, 1] {
//        //                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
//        return [Run(start:  2, length: 1, associatedHintIndex: 0, associatedPath: 1..<7),
//                Run(start:  5, length: 2, associatedHintIndex: 1, associatedPath: 1..<7),
//                Run(start:  8, length: 2, associatedHintIndex: 2, associatedPath: 8..<14),
//                Run(start: 12, length: 1, associatedHintIndex: 3, associatedPath: 8..<14)]
//    }
//    if row == Mark.parse("|x|_|▓|_|▓|▓|▓|x|▓|▓|_|_|▓|_|x|") && hints == [1, 3, 3, 1] {
//        //                 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4
//        return [Run(start:  2, length: 1, associatedHintIndex: 0, associatedPath: 1..<7),
//                Run(start:  4, length: 3, associatedHintIndex: 1, associatedPath: 1..<7),
//                Run(start:  8, length: 2, associatedHintIndex: 2, associatedPath: 8..<14),
//                Run(start: 12, length: 1, associatedHintIndex: 3, associatedPath: 8..<14)]
//    }
    
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
        let assocGen6 = associateGen6(runs: assocGen5, to: hints, row: row)
        let assocGen7 = associateGen7(runs: assocGen6, to: hints, row: row)

        return assocGen7
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
    
    while !remainingRuns.isEmpty && hintIndex >= 0 {
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

func associateGen6(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    
    let unknowns = runsEx(row, of: .unknown)
    var chiseledAndUnkowns = runs.map({(mark: Mark.chiseled, run: $0)})

    chiseledAndUnkowns.append(contentsOf: unknowns.map({(mark: .unknown, run: $0)}))
    chiseledAndUnkowns.sort(by: {$0.run.start < $1.run.start})

    var hintIndex = 0
    var associatedRuns = [Run]()
    let paths = pathsEx(row, hints: hints)

    runsLoop:
    for (mark, run) in chiseledAndUnkowns {
        guard hintIndex < hints.count else { break }
        
        switch mark {
        case .chiseled:
            if let existingHintIndex = run.associatedHintIndex {
                hintIndex = existingHintIndex + 1
                associatedRuns.append(run)
                continue
            }
            
            
            if run.length < hints[hintIndex] {
                let path = paths.first(where: {$0.contains(run.start)})!
                
                associatedRuns.append(run.associate(with: hintIndex, path: path.range))
                
                break runsLoop
            } else {
                associatedRuns.append(run)
                hintIndex += 1
            }
        case .unknown:
            if run.length >= hints[hintIndex] {
                break runsLoop
            }
        default:
            fatalError()
        }
    }

    associatedRuns.append(contentsOf: runs.suffix(runs.count - associatedRuns.count))

    return associatedRuns
}

func associateGen7(runs: [Run], to hints: [Int], row: [Mark]) -> [Run] {
    guard hints.count == runs.count else { return runs }
    
    func distanceTooSmall(_ i: Int, _ j: Int) -> Bool {
        guard j < hints.count else { return false }
        
        let run1 = runs[i], run2 = runs[j]
        let combinedLength = run2.nextAfter - run1.start
        
        return combinedLength <= hints[i] && combinedLength <= hints[j]
    }
    
    let paths = pathsEx(row, hints: hints)
    var associatedRuns = [Run]()
    
    for i in 0..<hints.count {
        if distanceTooSmall(i, i + 1) {
            return runs
        }
        
        let run = runs[i]
        let path = paths.first(where: {$0.contains(run.start)})!
        
        associatedRuns.append(run.associate(with: i, path: path.range))
    }
    
    return associatedRuns
}
