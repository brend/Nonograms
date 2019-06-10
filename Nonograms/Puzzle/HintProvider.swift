//
//  HintProvider.swift
//  Nonograms
//
//  Created by Philipp Brendel on 10.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public struct HintProvider {
    let matrix: Matrix
    
    public init(matrix: Matrix) {
        self.matrix = matrix
    }
    
    public func hints() -> (rowHints: [[Int]], columnHints: [[Int]]) {
        let rowHints = matrix.rows().map { arrayHints($0) }
        let columnHints = matrix.columns().map { arrayHints($0) }
        
        return (rowHints, columnHints)
    }
    
    func arrayHints(_ integratable: Integratable) -> [Int] {
        let row = integratable.data(from: matrix)
        var hints = [Int]()
        var run = 0
        
        for mark in row {
            switch mark {
            case .chiseled:
                run += 1
            case .unknown:
                hints.append(run)
                run = 0
            default:
                fatalError()
            }
        }
        
        hints.append(run)
        
        let withoutZeroes = hints.filter {$0 != 0}
        
        return withoutZeroes.count > 0 ? withoutZeroes : [0]
    }
    
}
