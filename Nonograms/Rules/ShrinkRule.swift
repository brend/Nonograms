//
//  ShrinkRule.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

extension Array where Element == Int {
    func hintSum() -> Int {
        return self.reduce(0, +) + self.count
    }
}

public class ShrinkRule: Rule {
    public override var name: String { return "Shrink" }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {

        // test row length; can become too small from shrinking
        guard let maxHint = hints.max(),
            row.count >= maxHint
        else {
                return row
        }
        
        var alteredRow = row
        
        for (i, h) in hints.enumerated() {
            let leftHints = Array(hints[0..<i])
            let rightHints = Array(hints[(i+1)..<hints.count])
            
            let left = leftHints.hintSum()
            let right = row.count - rightHints.hintSum()
            let length = right - left
            
            if h > length / 2 {
                let blanks = length - h
                
                alteredRow = chisel(alteredRow, from: left + blanks, count: length - 2 * blanks)
            }
        }
        
        return alteredRow
//
//
//
//
//
//        var front = 0, back = hints.count - 1
//        var wallLeft = 0, wallRight = row.count
//
//        while true {
//            if front == back {
//                let h = hints[front]
//                let space = wallRight - wallLeft
//
//                if h > space / 2 {
//                    let blanks = space - h
//                    let numberOfColumnsToPaint = space - 2 * blanks
//
//                    return chisel(row, from: wallLeft + blanks, count: numberOfColumnsToPaint)
//                } else {
//                    return row
//                }
//            } else {
//                if hints[front] <= hints[back] {
//                    wallLeft += hints[front] + 1
//                    front += 1
//                } else {
//                    wallRight -= hints[back] + 1
//                    back -= 1
//                }
//            }
//        }
    }
    
    
}
