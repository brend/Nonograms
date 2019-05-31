//
//  CloseToLeftRule.swift
//  Picross
//
//  Created by Philipp Brendel on 31.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class CloseToLeftRule: Rule {
    override var name: String { return "Close to Left" }
    
    override var symmetric: Bool { return false }
    
    override func apply(to row: [Mark], hints: [Int]) -> [Mark] {
        guard let h = hints.first else { return row }
        
        let rs = runsEx(row, of: .chiseled)
        
        guard let run = rs.first else { return row }
        
        if run.start < h - 1 {
            return chisel(row, from: run.start, count: h - run.start)
        } else {
            return row
        }
    }
}
