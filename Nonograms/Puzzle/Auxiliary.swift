//
//  Auxiliary.swift
//  Picross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

func render(_ row: [Mark]) -> String {
    let something = row.reduce("") {"\($0)|\($1.rawValue)"}
    
    return something + "|"
}

