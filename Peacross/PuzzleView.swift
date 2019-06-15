//
//  PuzzleView.swift
//  Peacross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Foundation
import Cocoa
import Nonograms

class PuzzleView: NSView {
    
    var delegate: PuzzleViewDelegate? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    // MARK: - Puzzle Data

    var markedRow: Int? {
        didSet {
            setNeedsDisplay(bounds)
        }
    }
    
    var markedColumn: Int? {
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
    
    func boxRect(rowIndex: Int, columnIndex: Int) -> NSRect {
        let bs = boxSize
        let area = boxArea
        
        return
            NSRect(x: area.minX + CGFloat(columnIndex) * bs.width,
                   y: area.maxY - CGFloat(rowIndex + 1) * bs.height,
               width: bs.width,
               height: bs.height)
    }
    
    // MARK: - Rendering
    
    let theme = Theme.dotMatrix
    
    override func draw(_ dirtyRect: NSRect) {
        guard let delegate = delegate else {
            return
        }
        
        theme.backgroundColor.setFill()
        
        let path = NSBezierPath(rect: boxArea)
        
        path.fill()
        
        for row in 0..<delegate.puzzleSize {
            for column in 0..<delegate.puzzleSize {
                let mark = delegate.getMark(row: row, column: column)
                
                paint(mark: mark, row: row, column: column, size: delegate.puzzleSize)
            }
        }
        
        highlightRowAndColumn()
        
        for i in 0..<delegate.puzzleSize {
            drawRowHints(i)
            drawColumnHints(i)
        }
        
        for i in 0...delegate.puzzleSize {
            strokeRow(i)
            strokeColumn(i)
        }
    }
    
    func paint(mark: Mark, row: Int, column: Int, size: Int) {
        let br = boxRect(rowIndex: row, columnIndex: column)
        
        switch mark {
        case .unknown:
            theme.unknownBoxColor.setFill()
            NSBezierPath.fill(br)
        case .chiseled:
            theme.chiseledBoxColor.setFill()
            NSBezierPath.fill(br.insetBy(dx: 2, dy: 2))
        case .marked:
            theme.markedBoxColor.setFill()
            NSBezierPath.fill(br)
            theme.markColor.setStroke()
            let insetBoxRect = br.insetBy(dx: br.width / 3, dy: br.height / 3)
            NSBezierPath.strokeLine(from: insetBoxRect.topLeft, to: insetBoxRect.bottomRight)
            NSBezierPath.strokeLine(from: insetBoxRect.topRight, to: insetBoxRect.bottomLeft)
        default:
            fatalError()
        }
    }
    
    func strokeRow(_ rowIndex: Int) {
        let area = boxArea
        let y = area.minY + CGFloat(rowIndex) * boxSize.height
        let left = NSPoint(x: area.minX, y: y)
        let right = NSPoint(x: area.maxX, y: y)
        
        let path = NSBezierPath()

        if rowIndex.isMultiple(of: 5) {
            theme.rowRulerColor.setStroke()
            path.lineWidth = 2
        } else {
            theme.rowDividerColor.setStroke()
        }
        
        path.move(to: left)
        path.line(to: right)
        path.lineWidth = 2
        
        path.stroke()
    }
    
    func strokeColumn(_ columnIndex: Int) {
        let area = boxArea
        let x = area.minX + CGFloat(columnIndex) * boxSize.width
        let top = NSPoint(x: x, y: area.maxY)
        let bottom = NSPoint(x: x, y: area.minY)
        
        let path = NSBezierPath()

        if columnIndex.isMultiple(of: 5) {
            theme.columnRulerColor.setStroke()
            path.lineWidth = 2
        } else {
            theme.columnDividerColor.setStroke()
        }
        
        path.move(to: top)
        path.line(to: bottom)
        
        path.stroke()
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
        let hintCoords = CGPoint(x: boxArea.minX + boxSize.width * (CGFloat(columnIndex) + 0.3),
                                 y: boxArea.maxY)
        
        hintText.draw(at: hintCoords, withAttributes: attrs)
    }
    
    func highlightRowAndColumn() {
        theme.moveHighlightColor.setFill()
        
        if let columnIndex = markedColumn {
            let colRect = NSRect(x: boxArea.minX + boxSize.width * CGFloat(columnIndex),
                                 y: boxArea.minY,
                                 width: boxSize.width,
                                 height: boxArea.height)
            
            NSBezierPath.fill(colRect)
        }
        
        if let rowIndex = markedRow,
            let size = delegate?.puzzleSize {
            let rowRect = NSRect(x: boxArea.minX,
                                 y: boxArea.minY + CGFloat(size - (rowIndex + 1)) * boxSize.height,
                                 width: boxArea.width,
                                 height: boxSize.height)

            NSBezierPath.fill(rowRect)
        }
    }
    
    // MARK: - User Interaction
    
    override func mouseDown(with event: NSEvent) {
        if let (rowIndex, columnIndex) = coordinates(from: event),
            let existingMark = delegate?.getMark(row: rowIndex, column: columnIndex) {
            
            let mark = (existingMark == .chiseled) ? Mark.unknown : .chiseled
            
            delegate?.setMark(row: rowIndex, column: columnIndex, mark: mark)
            
            setNeedsDisplay(bounds)
            
            dragMark = mark
        }
    }
    
    var dragMark = Mark.chiseled
    
    override func mouseDragged(with event: NSEvent) {
        guard NSEvent.pressedMouseButtons == 1 else { return }
        
        guard let (rowIndex, columnIndex) = coordinates(from: event)
            else { return }
        
        delegate?.setMark(row: rowIndex, column: columnIndex, mark: dragMark)
        
        setNeedsDisplay(bounds)
    }
    
    func coordinates(from event: NSEvent) -> (rowIndex: Int, columnIndex: Int)? {
        guard let size = delegate?.puzzleSize else { return nil }
        
        let coordsInView = self.convert(event.locationInWindow, from: nil)
        let area = boxArea
        let rowIndex = Int((coordsInView.y - area.minY) / boxSize.height)
        let columnIndex = Int((coordsInView.x - area.minX) / boxSize.width)
        
        guard rowIndex >= 0 && rowIndex < size
            && columnIndex >= 0 && columnIndex < size
            else {
                return nil
        }
        
        return (size - (rowIndex + 1), columnIndex)
    }
}
