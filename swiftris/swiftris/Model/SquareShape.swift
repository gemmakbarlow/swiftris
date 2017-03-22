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
            Orientation.zero: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.oneEighty: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.ninety: [(0, 0), (1, 0), (0, 1), (1, 1)],
            Orientation.twoSeventy: [(0, 0), (1, 0), (0, 1), (1, 1)]
            ]
    }
    
    // #3
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.oneEighty:  [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.ninety:     [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.twoSeventy: [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]]
            ]
    }
}
