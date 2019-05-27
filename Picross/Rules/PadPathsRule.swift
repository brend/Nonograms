//
//  PadPathsRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class PadPathsRule: PathsRule {
    override var name: String { return "pad paths" }
    
    override func applyToPath(_ path: [Mark], hint: Int) -> [Mark] {
        guard let anchorLeft = path.firstIndex(of: .chiseled),
            let anchorRight = path.lastIndex(of: .chiseled)
        else { return path }
        
        let h = hint
        let anchorWidth = anchorRight - anchorLeft + 1
        var alteredRow = path
        
        for i in 0..<alteredRow.count {
            if i < (anchorLeft - (h - anchorWidth))
                || i > (anchorRight + (h - anchorWidth)) {
                alteredRow[i] = .marked
            }
        }
        
        return alteredRow
    }
}
