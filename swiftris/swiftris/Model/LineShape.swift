//
//  LineShape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

// GB - Taken straight from the tutorial! 

class LineShape:Shape {
    /*
    Orientations 0 and 180:
    
    | 0•|
    | 1 |
    | 2 |
    | 3 |
    
    Orientations 90 and 270:
    
    | 0 | 1•| 2 | 3 |
    
    • marks the row/column indicator for the shape
    
    */
    
    // Hinges about the second block
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.ninety:     [(-1,0), (0, 0), (1, 0), (2, 0)],
            Orientation.oneEighty:  [(0, 0), (0, 1), (0, 2), (0, 3)],
            Orientation.twoSeventy: [(-1,0), (0, 0), (1, 0), (2, 0)]
            ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[FourthBlockIndex]],
            Orientation.ninety:     blocks,
            Orientation.oneEighty:  [blocks[FourthBlockIndex]],
            Orientation.twoSeventy: blocks
            ]
    }
}
