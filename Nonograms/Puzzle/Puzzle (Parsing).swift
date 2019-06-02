//
//  Puzzle (Parsing).swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

extension Puzzle {
    public static func parse(file: String) -> Puzzle {
        guard let text = try? String(contentsOfFile: file) else {
            fatalError("could not read file")
        }
        
        let lines =
            text
                .components(separatedBy: .newlines)
                .map {$0.trimmingCharacters(in: .whitespaces)}
        
        enum ActiveSet {
            case none, rows, columns, ignore, solution
        }
        
        var rowHints = [[Int]]()
        var columnHints = [[Int]]()
        var active = ActiveSet.none
        var solution = [String]()
        
        for line in lines {
            switch line {
            case "rows":
                active = .rows
            case "columns":
                active = .columns
            case "comment":
                active = .ignore
            case "solution":
                active = .solution
            case "":
                continue
            default:
                switch active {
                case .none:
                    fatalError("no action set")
                case .ignore:
                    continue;
                case .solution:
                    solution.append(line)
                case .rows, .columns:
                    let numbers = line.components(separatedBy: ",").map({Int($0) ?? -1})
                    
                    if active == .rows {
                        rowHints.append(numbers)
                    } else {
                        columnHints.append(numbers)
                    }
                }
            }
        }
        
        guard rowHints.count == columnHints.count else {
            fatalError("expected identical amounts of row and column hints")
        }
        
        guard rowHints.count.isMultiple(of: 5) else {
            fatalError("expected hint count to be multiple of 5")
        }
        
        let puzzle: Puzzle
        
        if solution.isEmpty {
            puzzle = Puzzle(rowHints: rowHints, columnHints: columnHints)
        } else {
            var solutionMatrix = Matrix(size: rowHints.count)
            
            for (rowIndex, line) in solution.enumerated() {
                let interestingChars = line.filter({$0=="_" || $0=="▓"})
                
                for (columnIndex, c) in interestingChars.enumerated() {
                    if c == "▓" {
                        solutionMatrix[rowIndex, columnIndex] = .chiseled
                    }
                }
            }
            
            puzzle = Puzzle(solution: solutionMatrix)
        }
            
        return puzzle
    }
}
