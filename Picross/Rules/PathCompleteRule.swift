//
//  PathCompleteRule.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class PathCompleteRule: PathsRule {
    override func applyToPath(_ path: [Mark], hint: Int) -> [Mark] {
        guard let anchorLeft = path.firstIndex(of: .chiseled),
            let anchorRight = path.lastIndex(of: .chiseled)
            else { return path }
        
        var alteredPath = path
        
        for i in anchorLeft...anchorRight {
            alteredPath[i] = .chiseled
        }
        
        return alteredPath
    }
}
