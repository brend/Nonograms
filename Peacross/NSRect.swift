//
//  NSRect.swift
//  Peacross
//
//  Created by Philipp Brendel on 01.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation

extension NSRect {
    var topLeft: NSPoint {
        return NSPoint(x: self.minX, y: self.maxY)
    }
    
    var topRight: NSPoint {
        return NSPoint(x: self.maxX, y: self.maxY)
    }
    
    var bottomLeft: NSPoint {
        return NSPoint(x: self.minX, y: self.minY)
    }
    
    var bottomRight: NSPoint {
        return NSPoint(x: self.maxX, y: self.minY)
    }
}
