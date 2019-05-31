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
    
    // MARK: - Geometry
    
    var boxArea: NSRect {
        return NSRect(x: bounds.minX + horizontalGutterSize,
                      y: bounds.minY,
                      width: bounds.width - horizontalGutterSize,
                      height: bounds.height - verticalGutterSize)
    }
    
    let horizontalGutterSize = CGFloat(100)
    
    let verticalGutterSize = CGFloat(100)
    
    var boxSize: NSSize {
        let area = boxArea
        let size = delegate?.puzzleSize ?? 1
        let boxCount = CGFloat(size)
        
        let boxWidth = area.width / CGFloat(boxCount)
        let boxHeight = area.height / CGFloat(boxCount)
        
        return NSSize(width: boxWidth, height: boxHeight)
    }
    
    // MARK: - Rendering
    
    override func draw(_ dirtyRect: NSRect) {
        guard let delegate = delegate else {
            return
        }
        
        NSColor.controlHighlightColor.setFill()
        
        let path = NSBezierPath(rect: bounds)
        
        path.fill()
        
        for row in 0..<delegate.puzzleSize {
            for column in 0..<delegate.puzzleSize {
                let mark = delegate.getMark(row: row, column: column)
                
                paint(mark: mark, row: row, column: column, size: delegate.puzzleSize)
            }
        }
        
        for i in 0..<delegate.puzzleSize {
            NSColor.white.setStroke()
            strokeRow(i)
            strokeColumn(i)
            drawRowHints(i)
            drawColumnHints(i)
        }
    }
    
    func paint(mark: Mark, row: Int, column: Int, size: Int) {
        let area = boxArea
        let bs = boxSize
        
        let boxRect = NSRect(x: area.minX + CGFloat(column) * bs.width,
                             y: area.maxY - CGFloat(row + 1) * bs.height,
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
        let y = area.minY + CGFloat(rowIndex) * boxSize.height
        let left = NSPoint(x: area.minX, y: y)
        let right = NSPoint(x: area.maxX, y: y)
        
        NSBezierPath.strokeLine(from: left, to: right)
    }
    
    func strokeColumn(_ columnIndex: Int) {
        let area = boxArea
        let x = area.minX + CGFloat(columnIndex) * boxSize.width
        let top = NSPoint(x: x, y: area.maxY)
        let bottom = NSPoint(x: x, y: area.minY)
        
        NSBezierPath.strokeLine(from: top, to: bottom)
    }
    
    let hintFont = NSFont(name: "Courier New", size: 18)
    
    func drawRowHints(_ rowIndex: Int) {
        
        guard let hints = delegate?.rowHints(for: rowIndex) else { return }
        
        let hintText = hints.map {String($0)}.joined(separator: " ") as NSString
        let attrs = [NSAttributedString.Key.font: hintFont as Any]
        let textSize = hintText.size(withAttributes: attrs)
        let hintCoords = CGPoint(x: boxArea.minX - textSize.width, y: boxArea.maxY - boxSize.height * CGFloat(rowIndex + 1))
        
        hintText.draw(at: hintCoords, withAttributes: attrs)
    }
    
    func drawColumnHints(_ columnIndex: Int) {
        guard let hints = delegate?.columnHints(for: columnIndex) else { return }
        
        let hintText = hints.map {String($0)}.joined(separator: "\n") as NSString
        let attrs = [NSAttributedString.Key.font: hintFont as Any]
        //let textSize = hintText.size(withAttributes: attrs)
        let hintCoords = CGPoint(x: boxArea.minX + boxSize.width * CGFloat(columnIndex),
                                 y: boxArea.maxY)
        
        hintText.draw(at: hintCoords, withAttributes: attrs)
    }
    
    // MARK: - User Interaction
    
    override func mouseDown(with event: NSEvent) {
        if let (rowIndex, columnIndex) = coordinates(from: event),
            let existingMark = delegate?.getMark(row: rowIndex, column: columnIndex) {
            
            let mark = (existingMark == .chiseled) ? Mark.unknown : .chiseled
            
            delegate?.setMark(row: rowIndex, column: columnIndex, mark: mark)
            setNeedsDisplay(bounds)
        }
    }
    
    func coordinates(from event: NSEvent) -> (rowIndex: Int, columnIndex: Int)? {
        guard let size = delegate?.puzzleSize else { return nil }
        
        let coordsInView = convert(event.locationInWindow, to: self)
        let area = boxArea
        let rowIndex = Int((coordsInView.y - area.minY - boxSize.height / 2) / boxSize.height)
        let columnIndex = Int((coordsInView.x - area.minX - boxSize.width / 2) / boxSize.width)
        
        guard rowIndex >= 0 && rowIndex < size
            && columnIndex >= 0 && columnIndex < size
            else {
                return nil
        }
        
        return (size - (rowIndex + 1), columnIndex)
    }
}
