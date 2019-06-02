//
//  SolutionStep.swift
//  Picross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public struct SolutionStep: CustomStringConvertible {
    public let row: Integratable
    public let before, after: [Mark]
    public let rule: Rule
    
    public var description: String {
        return "apply \(rule.name) to \(row): \(before) -> \(after)"
    }
}
