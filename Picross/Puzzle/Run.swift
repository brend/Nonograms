//
//  Run.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct Run {
    let index, start, length: Int
}

func runsEx(_ row: [Mark], of mark: Mark) -> [Run] {
    var runs = [Run]()
    var index = 0
    var currentRunLength = 0
    
    for i in 0..<row.count {
        if row[i] == mark {
            currentRunLength += 1
        } else if currentRunLength > 0 {
            runs.append(Run(index: index, start: i - currentRunLength, length: currentRunLength))
            currentRunLength = 0
            index += 1
        }
    }
    
    if currentRunLength > 0 {
        runs.append(Run(index: index, start: row.count - currentRunLength, length: currentRunLength))
    }
    
    return runs
}
