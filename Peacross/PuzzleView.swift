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
        
        highlightRowAndColumn()
        
        for i in 0..<delegate.puzzleSize {
            strokeRow(i)
            strokeColumn(i)
            drawRowHints(i)
            drawColumnHints(i)
        }
    }
    
    func paint(mark: Mark, row: Int, column: Int, size: Int) {
        let br = boxRect(rowIndex: row, columnIndex: column)
        
        switch mark {
        case .unknown:
            NSColor.lightGray.setFill()
            NSBezierPath.fill(br)
        case .chiseled:
            NSColor.darkGray.setFill()
            NSBezierPath.fill(br)
        case .marked:
            //NSColor.red.setFill()
            NSColor.lightGray.setFill()
            NSBezierPath.fill(br)
            NSColor.darkGray.setStroke()
            let insetBoxRect = br.insetBy(dx: br.width / 8, dy: br.height / 8)
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
        
        if rowIndex.isMultiple(of: 5) {
            NSColor(deviceRed: 0.51, green: 0.80, blue: 96, alpha: 1).setStroke()
        } else {
            NSColor.white.setStroke()
        }
        
        NSBezierPath.strokeLine(from: left, to: right)
    }
    
    func strokeColumn(_ columnIndex: Int) {
        let area = boxArea
        let x = area.minX + CGFloat(columnIndex) * boxSize.width
        let top = NSPoint(x: x, y: area.maxY)
        let bottom = NSPoint(x: x, y: area.minY)
        
        if columnIndex.isMultiple(of: 5) {
            NSColor(deviceRed: 0.51, green: 0.80, blue: 96, alpha: 1).setStroke()
        } else {
            NSColor.white.setStroke()
        }
        
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
        let hintCoords = CGPoint(x: boxArea.minX + boxSize.width * (CGFloat(columnIndex) + 0.3),
                                 y: boxArea.maxY)
        
        hintText.draw(at: hintCoords, withAttributes: attrs)
    }
    
    func highlightRowAndColumn() {
        NSColor(deviceRed: 0, green: 0, blue: 1, alpha: 0.2).setFill()
        
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
    
//    func previewNextStep() {
//        guard phase == .displayIntegration,
//            let step = step
//        else { return }
//
//        NSColor(deviceRed: 1, green: 0, blue: 0, alpha: 0.3).setFill()
//
//        switch step.row {
//        case let c as ColumnIntegratable:
//            let colRect = NSRect(x: boxArea.minX + boxSize.width * CGFloat(c.columnIndex), y: boxArea.maxY, width: boxSize.width, height: boxArea.height)
//            NSBezierPath.fill(colRect)
//
//            for (i, mark) in step.after.enumerated() {
//                switch mark {
//                case .chiseled:
//                    NSBezierPath.fill(boxRect(rowIndex: i, columnIndex: c.columnIndex))
//                case .marked:
//                    break
//                default:
//                    break
//                }
//            }
//
//            break
//        case let r as RowIntegratable:
//            let rowRect = NSRect(x: boxArea.minX, y: boxArea.minY + CGFloat(r.rowIndex) * boxSize.height, width: boxArea.width, height: boxSize.height)
//
//            NSBezierPath.fill(rowRect)
//
//            for (i, mark) in step.after.enumerated() {
//                switch mark {
//                case .chiseled:
//                    NSColor.green.setFill()
//                    NSBezierPath.fill(boxRect(rowIndex: r.rowIndex, columnIndex: i))
//                case .marked:
//                    let boxRect = NSRect(x: boxArea.minX + boxSize.width * CGFloat(i), y: boxArea.minY + CGFloat(r.rowIndex) * boxSize.height, width: boxSize.width, height: boxSize.height)
//
//                    NSColor.red.setFill()
//                    NSBezierPath.fill(boxRect)
//                default:
//                    break
//                }
//            }
//
//            break
//        default:
//            break
//        }
//
//        NSString("preview").draw(at: NSPoint(x: 10, y: 10), withAttributes: nil)
//    }
    
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
