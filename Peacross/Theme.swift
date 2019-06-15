//
//  Theme.swift
//  Peacross
//
//  Created by Philipp Brendel on 15.06.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation
import Cocoa

struct Theme {
    let backgroundColor: NSColor
    let unknownBoxColor: NSColor
    let chiseledBoxColor: NSColor
    let markedBoxColor: NSColor
    let markColor: NSColor
    let rowRulerColor: NSColor
    let columnRulerColor: NSColor
    let rowDividerColor: NSColor
    let columnDividerColor: NSColor
    let moveHighlightColor: NSColor
    
    init(backgroundColor: NSColor,
         unknownBoxColor: NSColor,
         chiseledBoxColor: NSColor,
         markedBoxColor: NSColor,
         markColor: NSColor,
         rowRulerColor: NSColor,
         columnRulerColor: NSColor,
         rowDividerColor: NSColor,
         columnDividerColor: NSColor,
         moveHighlightColor: NSColor) {
        self.backgroundColor = backgroundColor
        self.unknownBoxColor = unknownBoxColor
        self.chiseledBoxColor = chiseledBoxColor
        self.markedBoxColor = markedBoxColor
        self.markColor = markColor
        self.rowRulerColor = rowRulerColor
        self.columnRulerColor = columnRulerColor
        self.rowDividerColor = rowDividerColor
        self.columnDividerColor = columnDividerColor
        self.moveHighlightColor = moveHighlightColor
    }
    
    init() {
        backgroundColor = NSColor.lightGray
        unknownBoxColor = NSColor.lightGray
        chiseledBoxColor = NSColor.darkGray
        markedBoxColor = NSColor.lightGray
        markColor = NSColor.darkGray
        rowRulerColor = NSColor(deviceRed: 0.51, green: 0.80, blue: 96, alpha: 1)
        columnRulerColor = NSColor(deviceRed: 0.51, green: 0.80, blue: 96, alpha: 1)
        rowDividerColor = NSColor.white
        columnDividerColor = NSColor.white
        moveHighlightColor = NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 0.2)
    }
    
    static var dotMatrix =
        Theme(backgroundColor: NSColor(deviceRed: 0.76, green: 0.77, blue: 0.61, alpha: 1),
              unknownBoxColor: NSColor(deviceRed: 0.76, green: 0.77, blue: 0.61, alpha: 1),
              chiseledBoxColor: NSColor(deviceRed: 0.35, green: 0.35, blue: 0.25, alpha: 1),
              markedBoxColor: NSColor(deviceRed: 0.76, green: 0.77, blue: 0.61, alpha: 1),
              markColor: NSColor(deviceRed: 0.35, green: 0.35, blue: 0.25, alpha: 1),
              rowRulerColor: NSColor(deviceRed: 0.23, green: 0.22, blue: 0.15, alpha: 1),
              columnRulerColor: NSColor(deviceRed: 0.23, green: 0.22, blue: 0.15, alpha: 1),
              rowDividerColor: NSColor(deviceRed: 0.59, green: 0.58, blue: 0.47, alpha: 1),
              columnDividerColor: NSColor(deviceRed: 0.59, green: 0.58, blue: 0.47, alpha: 1),
              moveHighlightColor: NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 0.2))
}

