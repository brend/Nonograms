//
//  Puzzle (Parsing).swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct PuzzleParseError: Error {
    let message: String
}

extension Puzzle {
    
    public static func parse(peaFile file: String) throws -> Puzzle {
        guard let text = try? String(contentsOfFile: file) else {
            fatalError("could not read file")
        }
        
        let lines =
            text
                .components(separatedBy: .newlines)
                .map {$0.trimmingCharacters(in: .whitespaces)}
        
        enum ActiveSet {
            case none, rows, columns, ignore
        }
        
        var rowHints = [[Int]]()
        var columnHints = [[Int]]()
        var active = ActiveSet.none
        
        for line in lines {
            switch line {
            case "rows":
                active = .rows
            case "columns":
                active = .columns
            case "comment":
                active = .ignore
            case "":
                continue
            default:
                switch active {
                case .none:
                    throw PuzzleParseError(message: "no action directive found")
                case .ignore:
                    continue;
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
        
        return Puzzle(rowHints: rowHints, columnHints: columnHints)
    }
}
