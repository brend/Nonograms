//
//  PuzzleView.swift
//  Peacross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation
import Cocoa

class PuzzleView: NSView {
    
    var delegate: PuzzleViewDelegate? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let delegate = delegate else {
            return
        }
        
        NSColor.blue.setFill()
        
        let path = NSBezierPath(rect: frame)
        
        path.fill()
        
        for row in 0..<delegate.puzzleSize {
            for column in 0..<delegate.puzzleSize {
                let mark = delegate.getMark(row: row, column: column)
                
                paint(mark: mark, row: row, column: column, size: delegate.puzzleSize)
            }
        }
        
        NSColor.white.setStroke()
        
        for i in 0..<delegate.puzzleSize {
            strokeRow(i)
            strokeColumn(i)
        }        
    }
    
    var boxArea: NSRect {
        return bounds
    }
    
    var boxSize: NSSize {
        let area = boxArea
        let size = delegate?.puzzleSize ?? 1
        let boxCount = CGFloat(size)
        
        let boxWidth = area.width / CGFloat(boxCount)
        let boxHeight = area.height / CGFloat(boxCount)
        
        return NSSize(width: boxWidth, height: boxHeight)
    }
    
    func paint(mark: Mark, row: Int, column: Int, size: Int) {
        let area = boxArea
        let bs = boxSize
        
        let boxRect = NSRect(x: area.minX + CGFloat(column) * bs.width,
                             y: area.minY + CGFloat(row) * bs.height,
                         width: bs.width,
                        height: bs.height)
        
        switch mark {
        case .unknown:
            NSColor.lightGray.setFill()
        case .chiseled:
            NSColor.darkGray.setFill()
        case .marked:
            NSColor.red.setFill()
        }
        
        NSBezierPath.fill(boxRect)
    }
    
    func strokeRow(_ rowIndex: Int) {
        let area = boxArea
        let y = CGFloat(rowIndex) * boxSize.height
        let left = NSPoint(x: area.minX, y: y)
        let right = NSPoint(x: area.maxX, y: y)
        
        NSBezierPath.strokeLine(from: left, to: right)
    }
    
    func strokeColumn(_ columnIndex: Int) {
        let area = boxArea
        let x = CGFloat(columnIndex) * boxSize.width
        let top = NSPoint(x: x, y: area.maxY)
        let bottom = NSPoint(x: x, y: area.minY)
        
        NSBezierPath.strokeLine(from: top, to: bottom)
    }
}
