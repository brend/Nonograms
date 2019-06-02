//
//  Array.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

func minimalLength(hints: [Int]) -> Int {
    guard hints.count > 0 else {
        return 0
    }
    
    return hints.reduce(0, +) + hints.count - 1
}
