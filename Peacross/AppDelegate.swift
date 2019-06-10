//
//  AppDelegate.swift
//  Peacross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Cocoa
import Nonograms

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PuzzleViewDelegate {
    
    enum DocMode {
        case editPuzzle, solvePuzzle
    }
    
    var puzzleSize: Int { return solutionState.size }
    
    var rowHints = [[Int]](repeating: [0], count: 5)
    
    var columnHints = [[Int]](repeating: [0], count: 5)
    
    func getMark(row: Int, column: Int) -> Mark {
        return solutionState[row, column]
    }
    
    func setMark(row: Int, column: Int, mark: Mark) {
        solutionState[row, column] = mark
        recalculateHints()
    }
    
    func rowHints(for rowIndex: Int) -> [Int] {
        return rowHints[rowIndex]
    }
    
    func columnHints(for columnIndex: Int) -> [Int] {
        return columnHints[columnIndex]
    }
    
    func recalculateHints() {
        let hintProvider = HintProvider(matrix: solutionState)
        
        (rowHints, columnHints) = hintProvider.hints()
    }

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var puzzleView: PuzzleView!

    @IBOutlet weak var ruleLabel: NSTextField!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        puzzleView.delegate = self
        puzzleView.becomeFirstResponder()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    @IBAction func saveDocument(_ sender: Any?) {
        
        fatalError("not implemented")
        
        let savePanel = NSSavePanel()
        
        guard savePanel.runModal() == .OK,
            let url = savePanel.url
            else { return }
        
//        let text = puzzle.toPeaFile()
//
//        guard let data = text.data(using: .utf8) else { return }
//
//        do {
//            try data.write(to: url)
//        } catch {
//            print("\(error)")
//        }
    }
    
    var mode = DocMode.editPuzzle
    
    @IBAction func openDocument(_ sender: Any) {
        let openPanel = NSOpenPanel()
        
        guard openPanel.runModal() == .OK,
            let url = openPanel.url else {
                return
        }
        
        steps = nil
        stepIndex = 0
        solutionState = Matrix(size: 5)
        rowHints = [[Int]](repeating: [0], count: 5)
        columnHints = [[Int]](repeating: [0], count: 5)
        mode = .editPuzzle
        
        switch url.pathExtension.lowercased() {
        case "matrix":
            guard let matrix = try? Matrix.parse(matrixFile: url.path)
                else { fatalError() }
            
            solutionState = matrix
            mode = .editPuzzle
        case "pea":
            let puzzle: Puzzle
            
            do {
                puzzle = try Puzzle.parse(peaFile: url.path)
            } catch {
                NSAlert(error: error).runModal()
                return
            }
            
            solutionState = Matrix(size: puzzle.size)
            rowHints = puzzle.rowHints
            columnHints = puzzle.columnHints
            steps = puzzle.solve()
            mode = .solvePuzzle
        default:
            fatalError()
        }
        
        puzzleView.setNeedsDisplay(puzzleView.bounds)
    }
    
    // MARK: - Stepping Through the Solution
    
    var steps: [SolutionStep]?
    
    var stepIndex = 0
    
    var solutionState = Matrix(size: 5)
    
    @IBAction func nextStep(_ sender: Any) {
        
        guard mode == .solvePuzzle else { return }
        
        guard let steps = steps,
            stepIndex < steps.count
        else { return }
        
        var state = solutionState
        let step = steps[stepIndex]
        let row = step.row
        
        row.integrate(data: step.after, into: &state)
        
        solutionState = state
        
        let (rowIndex, columnIndex) = row.unpack()
        
        puzzleView.markedRow = rowIndex
        puzzleView.markedColumn = columnIndex
        
        ruleLabel.stringValue = step.rule.name
        
        stepIndex += 1
    }
}

