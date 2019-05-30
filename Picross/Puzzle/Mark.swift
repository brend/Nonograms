//
//  Mark.swift
//  Picross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

enum Mark: String {
    case unknown = "_",
    chiseled = "▓",
    marked = "x"
    
    func integrates(with mark: Mark) -> Bool {
        switch self {
        case .unknown:
            return true
        case .chiseled:
            return mark == .unknown || mark == .chiseled
        case .marked:
            return mark == .unknown || mark == .marked
        }
    }
}
