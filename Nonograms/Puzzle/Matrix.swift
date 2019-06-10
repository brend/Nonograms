//
//  Matrix.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public struct Matrix: Equatable {
    var values: [Mark]
    public let size: Int
    
    public init(size: Int) {
        self.size = size
        self.values = Array(repeating: .unknown, count: size * size)
    }
    
    public subscript(row: Int, column: Int) -> Mark {
        get {
            guard row >= 0 && row < size && column >= 0 && column < size else {
                fatalError("invalid subscript: (\(row), \(column))")
            }
            return values[row * size + column]
        }
        set {
            guard row >= 0 && row < size && column >= 0 && column < size else {
                fatalError("invalid subscript: (\(row), \(column))")
            }
            values[row * size + column] = newValue
        }
    }
    
    public func row(_ index: Int) -> [Mark] {
        guard index >= 0 && index < size else {
            fatalError("invalid index: \(index)")
        }
        
        return Array(values[index * size..<(index+1)*size])
    }
    
    public func column(_ index: Int) -> [Mark] {
        guard index >= 0 && index < size else {
            fatalError("invalid index :\(index)")
        }
        
        var col = Array(repeating: Mark.unknown, count: size)
        
        for row in 0..<size {
            col[row] = self[row, index]
        }
        
        return col
    }
    
    public func renderMatrix() -> String {
        var text = ""

        for i in 0..<size {
            let r = row(i)
            
            text.append(render(r))
            text.append("\n")
        }
        
        return text
    }
    
    public func printMatrix() {
        print(renderMatrix())
    }
    
    public mutating func integrate(row: [Mark], at rowIndex: Int) {
        for (i, m) in row.enumerated() {
            if m != .unknown {
                guard self[rowIndex, i].integrates(with: m) else {
                    fatalError("inconsistent marks")
                }
                
                self[rowIndex, i] = m
            }
        }
    }
    
    public mutating func integrate(column: [Mark], at columnIndex: Int) {
        for (i, m) in column.enumerated() {
            if m != .unknown {
                guard self[i, columnIndex].integrates(with: m) else {
                    fatalError("inconsistent marks")
                }
                
                self[i, columnIndex] = m
            }
        }
    }
    
    func rows() -> [Integratable] {
        var rows = [Integratable]()
        
        for i in 0..<size {
            rows.append(RowIntegratable(rowIndex: i))
        }
        
        return rows
    }
    
    func columns() -> [Integratable] {
        var columns = [Integratable]()
        
        for i in 0..<size {
            columns.append(ColumnIntegratable(columnIndex: i))
        }
        
        return columns
    }
    
    func rowsAndColumns() -> [Integratable] {
        var rowsAndColumns = [Integratable]()
        
        for i in 0..<size {
            rowsAndColumns.append(RowIntegratable(rowIndex: i))
            rowsAndColumns.append(ColumnIntegratable(columnIndex: i))
        }
        
        return rowsAndColumns
    }
    
}
