//
//  Mark.swift
//  Picross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

public enum Mark: String, CustomStringConvertible {
    case unknown = "_",
        chiseled = "▓",
        marked = "x"
    
    case hypotheticalMark = "+"
    
    func integrates(with mark: Mark) -> Bool {
        switch self {
        case .unknown:
            return true
        case .chiseled:
            return mark == .unknown || mark == .chiseled
        case .marked:
            return mark == .unknown || mark == .marked
        default:
            fatalError()
        }
    }
    
    public var description: String {
        return self.rawValue
    }
    
    public static func parse(_ row: String) -> [Mark] {
        return row
            .map {Mark(rawValue: $0.description)}
            .filter {$0 != nil}
            .map {$0!}
    }
}
