//
//  CloseSmallestUnassociatedPathRuleTest.swift
//  NonogramsTests
//
//  Created by Philipp Brendel on 08.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import XCTest
@testable import Nonograms

//class CloseSmallesUnassociatedPathRule: Rule {
//    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
//        let runs = runsEx(row, of: .chiseled, hints: hints)
//        var minHint = Int.max
//        var minHintIndex = Int.max
//        let associatedIndices = runs.map {$0.associatedHintIndex}
//
//        //let foo = hints.enumerated().min(by: {$0.element < $1.element}).filter {!associatedIndices.contains($0.offset)}
//
//        for (i, h) in hints.enumerated() {
//            guard !associatedIndices.contains(i) else { continue }
//
//            if h < minHint {
//                minHint = h
//                minHintIndex = i
//            }
//        }
//
//        guard minHintIndex < Int.max else { return row }
//
//        let paths = pathsEx(row, hints: hints)
//        let openPaths = paths.filter {!$0.slice(row).contains(.chiseled)}
//        let smallPaths = openPaths.filter({$0.length < minHint})
//        var alteredRow = row
//
//        for path in smallPaths {
//            alteredRow = chisel(alteredRow, from: path.start, count: path.length, mark: .marked)
//        }
//
//        return alteredRow
//    }
//}

class CloseUnusablePathsRuleTest: XCTestCase {
    
    let rule = CloseUnusablePathsRule()
    
//    func test1() {
//        let row      = Mark.parse("▓x__x_x__xxx▓▓▓")
//        let hints = [1, 2, 1, 3]
//        let expected = Mark.parse("▓x__xxx__xxx▓▓▓")
//        let actual = rule.apply(to: row, hints: hints)
//
//        XCTAssertEqual(expected, actual)
//    }
    
    func test1() {
        let row      = Mark.parse("▓x__x_x__xxx▓▓▓")
        let hints = [1, 2, 2, 3]
        let expected = Mark.parse("▓x__xxx__xxx▓▓▓")
        let actual = rule.apply(to: row, hints: hints)
        
        XCTAssertEqual(expected, actual)
    }
    
}
