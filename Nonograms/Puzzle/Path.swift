//
//  Paths.swift
//  Nonograms
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

func paths(in row: [Mark]) -> [Range<Int>] {
    var paths = [Range<Int>]()
    var lastMark = -1
    
    for (i, m) in row.enumerated() {
        if m == .marked {
            if lastMark < i - 1 {
                paths.append((lastMark + 1) ..< i)
            }
            lastMark = i
        }
    }
    
    if row.count > 0 && row.last! != .marked {
        paths.append((lastMark + 1)..<row.count)
    }
    
    return paths
}

struct Path: Equatable {
    let start, length: Int
    let associatedHintIndex: Int?
    
    init(start: Int,
        length: Int,
        associatedHintIndex: Int? = nil) {
        self.start = start
        self.length = length
        self.associatedHintIndex = associatedHintIndex
    }
    
    init(_ range: Range<Int>) {
        start = range.lowerBound
        length = range.count
        associatedHintIndex = nil
    }
    
    var nextAfter: Int { return start + length }
    
    func associate(with hintIndex: Int) -> Path {
        return Path(start: start, length: length, associatedHintIndex: hintIndex)
    }
    
    func contains(_ index: Int) -> Bool {
        return index >= start && index < start + length
    }
    
    func slice<T>(_ array: Array<T>) -> Array<T> {
        return Array(array[start..<nextAfter])
    }
    
    var range: Range<Int> { return start..<nextAfter }
}

func pathsEx(_ row: [Mark], hints: [Int]) -> [Path] {
    let ps = paths(in: row).map({Path($0)})
    
    guard ps.count == hints.count else {
        return ps
    }
    
    var associatedPaths = [Path]()
    
    for hintIndex in 0..<hints.count {
        let path = ps[hintIndex]
        let hint = hints[hintIndex]
        
        if hintIndex + 1 < hints.count {
            let nextHint = hints[hintIndex + 1]
            
            if hint + nextHint < path.length {
                return ps
            }
        }
        
        if hintIndex > 0 {
            let previousHint = hints[hintIndex - 1]
            
            if hint + previousHint < path.length {
                return ps
            }
        }
        
        associatedPaths.append(path.associate(with: hintIndex))
    }
    
    return associatedPaths
}
