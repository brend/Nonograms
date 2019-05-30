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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

