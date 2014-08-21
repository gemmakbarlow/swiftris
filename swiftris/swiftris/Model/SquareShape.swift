//
//  SquareShape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

// GB - Copied over from the tutorial, line for line.

class SquareShape:Shape {
    /*
    // #1
    | 0•| 1 |
    | 2 | 3 |
    
    • marks the row/column indicator for the shape
    
    */
    
    // The square shape will not rotate
    
    // #2
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.Zero: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.OneEighty: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.Ninety: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.TwoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
            ]
    }
    
    // #3
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.Zero:       [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.OneEighty:  [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.Ninety:     [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.TwoSeventy: [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]]
            ]
    }
}
