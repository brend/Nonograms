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
    
    public func apply(to matrix: Matrix) -> Matrix {
        var result = matrix
        
        row.integrate(data: after, into: &result)
        
        return result
    }
    
    public static func apply(steps: [SolutionStep], to matrix: Matrix) -> Matrix {
        var result = matrix
        
        for step in steps {
            result = step.apply(to: result)
        }
        
        return result
    }
}
