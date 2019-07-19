# Nonograms
A nonogram solver complete with GUI

##Using Nonograms
Nonograms consists of three parts.

### The Nonograms Framework
Main components:

* Matrix class: stores nonogram data; used for loading nonograms from disk and for manipulating them
* Rule class: base class for rules, i.e. transformations of nonogram data towards a solved form
* Puzzle class: coordinates rules and applies them on matrices until solved

Example: Creating a puzzle from a matrix and solving it

    // load a nonogram (the solution matrix) from a file
    let matrix = try Matrix.parse(matrixFile: "tower.matrix")
    // obtain the "hints", i.e. the numbers on the sides of the nonogram
    let (rowHints, columnHints) = HintProvider(matrix: matrix).hints()
    // create a puzzle from the hints
    let puzzle = Puzzle(rowHints: rowHints, columnHints: columnHints)    
    // use the default set of rules
    puzzle.rules = Rule.defaultSet
    // solve the puzzle; after this, "steps" contains the steps of the solution
    let steps = puzzle.solve(solution: matrix)

### Nonogram Tests
Tests to verify the operation of the rules and other components.

### The Peacross Application
A macOS application that can be used to either create new puzzles (matrices) and save them,
or load existing puzzles (in hint form), generate a solution and play back the steps
visually.
