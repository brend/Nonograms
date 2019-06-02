//
//  Puzzlable.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

protocol Puzzleable {
    var userRowHints: [[Int]] { get }
    var userColumnHints: [[Int]] { get }
    func mark(rowIndex: Int, columnIndex: Int) -> Mark
    func set(mark: Mark, rowIndex: Int, columnIndex: Int)
}
