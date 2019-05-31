//
//  PuzzleViewDelegate.swift
//  Peacross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

protocol PuzzleViewDelegate {
    var puzzleSize: Int { get }
    
    func getMark(row: Int, column: Int) -> Mark
    
    func setMark(row: Int, column: Int, mark: Mark)
    
    func rowHints(for rowIndex: Int) -> [Int]
    
    func columnHints(for columnIndex: Int) -> [Int]
}
