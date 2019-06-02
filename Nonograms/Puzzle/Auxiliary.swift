//
//  Auxiliary.swift
//  Picross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

func render(_ row: [Mark]) -> String {
    let something = row.reduce("") {"\($0)|\($1.rawValue)"}
    
    return something + "|"
}

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
