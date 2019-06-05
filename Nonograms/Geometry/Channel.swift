//
//  Channel.swift
//  Nonograms
//
//  Created by Philipp Brendel on 05.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

struct Channel: Equatable, CustomStringConvertible {
    let startIndex, length: Int
    let associatedHintIndex: Int?
    
    init(startIndex: Int, length: Int, associatedHintIndex: Int? = nil) {
        self.startIndex = startIndex
        self.length = length
        self.associatedHintIndex = associatedHintIndex
    }
    
    var upperBound: Int { return startIndex + length }
    
    var description: String {
        return "(\(startIndex), \(length)) -> \(String(describing: associatedHintIndex))"
    }
    
    func associate(hintIndex: Int) -> Channel {
        guard (self.associatedHintIndex ?? hintIndex) == hintIndex
        else { fatalError() }
        
        return Channel(startIndex: startIndex, length: length, associatedHintIndex: hintIndex)
    }
    
    static func from(row: [Mark]) -> [Channel] {
        var lastMarkIndex = -1
        var channels = [Channel]()
        
        for (i, mark) in row.enumerated() {
            guard mark == .marked else { continue }
            
            if lastMarkIndex < i - 1 {
                channels.append(Channel(startIndex: lastMarkIndex + 1, length: i - (lastMarkIndex + 1)))
            }
            
            lastMarkIndex = i
        }
        
        if lastMarkIndex < row.count - 1 {
            channels.append(Channel(startIndex: lastMarkIndex + 1, length: row.count - (lastMarkIndex + 1)))
        }
        
        return channels
    }
}
