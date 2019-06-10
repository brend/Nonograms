//
//  Matrix (Parsing).swift
//  Nonograms
//
//  Created by Philipp Brendel on 10.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct MatrixParseError: Error {
    let message: String
}

extension Matrix {
    public static func parse(matrixFile file: String) throws -> Matrix {
        
        guard let text = try? String(contentsOfFile: file) else {
            throw MatrixParseError(message: "could not open file")
        }
        
        let lines =
            text
                .components(separatedBy: .newlines)
                .map {$0.trimmingCharacters(in: .whitespaces)}
                .filter {!$0.isEmpty}
        
        var solutionMatrix = Matrix(size: lines.count)
        
        for (rowIndex, line) in lines.enumerated() {
            let interestingChars = line.filter({$0=="_" || $0=="▓"})
            
            for (columnIndex, c) in interestingChars.enumerated() {
                if c == "▓" {
                    solutionMatrix[rowIndex, columnIndex] = .chiseled
                }
            }
        }
        
        return solutionMatrix
    }
}
