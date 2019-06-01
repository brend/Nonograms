//
//  Integratable.swift
//  Picross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

protocol Integratable {
    func data(from matrix: Matrix) -> [Mark]
    func integrate(data: [Mark], into matrix: inout Matrix)
    func hints(_ puzzle: Puzzle) -> [Int]
    func unpack() -> (rowIndex: Int?, columnIndex: Int?)
}

struct ColumnIntegratable: Integratable, CustomStringConvertible {
    let columnIndex: Int
    
    func integrate(data: [Mark], into matrix: inout Matrix) {
        matrix.integrate(column: data, at: columnIndex)
    }
    
    func data(from matrix: Matrix) -> [Mark] {
        return matrix.column(columnIndex)
    }
    
    func hints(_ puzzle: Puzzle) -> [Int] {
        return puzzle.columnHints(columnIndex)
    }
    
    var description: String {
        return "column \(columnIndex)"
    }
    
    func unpack() -> (rowIndex: Int?, columnIndex: Int?) {
        return (nil, columnIndex)
    }
}

struct RowIntegratable: Integratable, CustomStringConvertible {
    let rowIndex: Int
    
    func data(from matrix: Matrix) -> [Mark] {
        return matrix.row(rowIndex)
    }
    
    func integrate(data: [Mark], into matrix: inout Matrix) {
        matrix.integrate(row: data, at: rowIndex)
    }
    
    func hints(_ puzzle: Puzzle) -> [Int] {
        return puzzle.rowHints(rowIndex)
    }
    
    var description: String {
        return "row \(rowIndex)"
    }
    
    func unpack() -> (rowIndex: Int?, columnIndex: Int?) {
        return (rowIndex, nil)
    }
}
