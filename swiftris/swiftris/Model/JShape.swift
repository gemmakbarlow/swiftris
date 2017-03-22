//
//  JShape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

// GB - Taken almost directly from the tutorial, minor adjustments

class JShape:Shape {
    /*
    
    Orientation 0
    
    • | 0 |
    | 1 |
    | 3 | 2 |
    
    Orientation 90
    
    | 3•|
    | 2 | 1 | 0 |
    
    Orientation 180
    
    | 2•| 3 |
    | 1 |
    | 0 |
    
    Orientation 270
    
    | 0•| 1 | 2 |
    | 3 |
    
    • marks the row/column indicator for the shape
    
    Pivots about `1`
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(1, 0), (1, 1),  (1, 2),  (0, 2)],
            Orientation.ninety:     [(2, 1), (1, 1),  (0, 1),  (0, 0)],
            Orientation.oneEighty:  [(0, 2), (0, 1),  (0, 0),  (1, 0)],
            Orientation.twoSeventy: [(0, 0), (1, 0),  (2, 0),  (2, 1)]
            ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.ninety:     [blocks[FirstBlockIndex], blocks[SecondBlockIndex], blocks[ThirdBlockIndex]],
            Orientation.oneEighty:  [blocks[FirstBlockIndex], blocks[FourthBlockIndex]],
            Orientation.twoSeventy: [blocks[FirstBlockIndex], blocks[SecondBlockIndex], blocks[FourthBlockIndex]]
            ]
    }
}
