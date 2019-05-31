//
//  AppDelegate.swift
//  Peacross
//
//  Created by Philipp Brendel on 27.05.19.
//  Copyright © 2019 Philipp Brendel. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, PuzzleViewDelegate {
    
    var puzzle: Puzzle? = Puzzle.demo
    
    var puzzleSize: Int { return puzzle?.size ?? 0 }
    
    func getMark(row: Int, column: Int) -> Mark {
        return puzzle?.mark(rowIndex: row, columnIndex: column) ?? .unknown
    }
    
    func setMark(row: Int, column: Int, mark: Mark) {
        puzzle?.set(mark: mark, rowIndex: row, columnIndex: column)
    }
    
    func rowHints(for rowIndex: Int) -> [Int] {
        return puzzle?.rowHints(rowIndex) ?? []
    }
    
    func columnHints(for columnIndex: Int) -> [Int] {
        return puzzle?.columnHints(columnIndex) ?? []
    }
    

    @IBOutlet weak var window: NSWindow!

    @IBOutlet weak var puzzleView: PuzzleView!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        puzzleView.delegate = self
        print(puzzleView.becomeFirstResponder())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func saveDocument(_ sender: Any?) {
        let savePanel = NSSavePanel()
        
        guard savePanel.runModal() == .OK,
            let url = savePanel.url
            else { return }
        
        guard let puzzle = puzzle else { return }
        
        let text = puzzle.toPeaFile()
        
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            try data.write(to: url)
        } catch {
            print("\(error)")
        }
    }
    
    @IBAction func openDocument(_ sender: Any) {
        let openPanel = NSOpenPanel()
        
        guard openPanel.runModal() == .OK,
            let url = openPanel.url else {
                return
        }
        
        let puzzle = Puzzle.parse(file: url.path)
        
        self.puzzle = puzzle
        
        puzzleView.setNeedsDisplay(puzzleView.bounds)
    }
    
}

