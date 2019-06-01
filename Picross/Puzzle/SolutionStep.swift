//
//  SolutionStep.swift
//  Picross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct SolutionStep: CustomStringConvertible {
    let row: Integratable
    let before, after: [Mark]
    let rule: Rule
    
    var description: String {
        return "apply \(rule.name) to \(row): \(before) -> \(after)"
    }
}
