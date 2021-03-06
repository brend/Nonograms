//
//  main.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation
import Nonograms

// test: the letter "L"
//m[0,1] = .chiseled
//m[0,2] = .chiseled
//m[1,1] = .chiseled
//m[1,2] = .chiseled
//m[2,1] = .chiseled
//m[2,2] = .chiseled
//m[3,1] = .chiseled
//m[3,2] = .chiseled
//m[4,1] = .chiseled
//m[4,2] = .chiseled
//m[4,3] = .chiseled
//m[4,4] = .chiseled

// test: the letter "P"
//m[0, 1] = .chiseled
//m[0, 2] = .chiseled
//m[0, 3] = .chiseled
//m[1, 1] = .chiseled
//m[1, 3] = .chiseled
//m[2, 1] = .chiseled
//m[2, 2] = .chiseled
//m[2, 3] = .chiseled
//m[3, 1] = .chiseled
//m[4, 1] = .chiseled

// killer ace of spades
//let puzzle = Puzzle(
//    rowHints:
//        [
//            [2],
//            [4],
//            [2, 3],
//            [2, 5],
//            [2, 4, 2],
//            [10],
//            [2, 2, 2],
//            [2],
//            [4],
//            [6]
//        ],
//    columnHints:
//        [
//            [2],
//            [4],
//            [2, 2, 1],
//            [2, 2, 2],
//            [2, 7],
//            [10],
//            [5, 2],
//            [2, 2, 1],
//            [4],
//            [2]
//        ])

// unsolvable without trial & error
//let puzzle =
//    Puzzle(
//        rowHints:
//        [
//            [2],
//            [6],
//            [6],
//            [8],
//            [8],
//            [2],
//            [3],
//            [3],
//            [2],
//            [6]
//        ],
//        columnHints:
//        [
//            [0],
//            [2],
//            [4, 1],
//            [4, 1, 1],
//            [10],
//            [10],
//            [4, 1, 1],
//            [4, 1],
//            [2],
//            [0]
//        ])

//let puzzle =
//    Puzzle(
//        rowHints:
//        [
//            [2],
//            [1, 1],
//            [4],
//            [4],
//            [4],
//            [1],
//            [8],
//            [6],
//            [4],
//            [0]
//        ],
//        columnHints:
//        [
//            [0],
//            [1],
//            [2],
//            [9],
//            [1, 3, 3],
//            [3, 3],
//            [3, 3],
//            [2],
//            [1, 1],
//            [0]
//        ])

//let puzzle = try! Puzzle.parse(peaFile: "/Users/waldrumpus/Downloads/toad.pea")
let matrix = try Matrix.parse(matrixFile: "/Users/waldrumpus/Downloads/tower.matrix")
let (rowHints, columnHints) = HintProvider(matrix: matrix).hints()
let puzzle = Puzzle(rowHints: rowHints, columnHints: columnHints)



puzzle.rules = Rule.defaultSet

let steps = puzzle.solve(solution: matrix)

print("end")
