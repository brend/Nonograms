//
//  MatchPaths.swift
//  Picross
//
//  Created by Philipp Brendel on 26.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

class MatchPathsRule: PathsRule {
    override var name: String { return "match paths" }
    
    let centerRule = CenterRule()
    
    override func applyToPath(_ path: [Mark], hint: Int) -> [Mark] {
        return centerRule.apply(to: path, hints: [hint])
    }
}
