//
//  Paths.swift
//  Nonograms
//
//  Created by Philipp Brendel on 02.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

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
