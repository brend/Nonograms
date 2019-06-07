//
//  Array.swift
//  Picross
//
//  Created by Philipp Brendel on 30.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

func minimalLength(hints: [Int]) -> Int {
    guard hints.count > 0 else {
        return 0
    }
    
    return hints.reduce(0, +) + hints.count - 1
}

extension Array where Element: Equatable {
    func index(of element: Element, startIndex: Int) -> Int? {
        guard startIndex >= 0 else { fatalError() }
        
        guard startIndex < self.count else { return nil }
        
        for i in startIndex..<self.count {
            if element == self[i] {
                return i
            }
        }
        
        return nil
    }
    
    mutating func replace(_ element: Element, with anotherElement: Element) {
        for i in 0..<count {
            if self[i] == element {
            self[i] = anotherElement
            }
        }
    }
}
