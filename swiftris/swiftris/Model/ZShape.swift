//
//  ZShape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

// GB - Taken almost directly from the tutorial

class ZShape:Shape {
    /*
    
    Orientation 0
    
    • | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 90
    
    | 0 | 1•|
    | 2 | 3 |
    
    Orientation 180
    
    • | 0 |
    | 2 | 1 |
    | 3 |
    
    Orientation 270
    
    | 0 | 1•|
    | 2 | 3 |
    
    
    • marks the row/column indicator for the shape
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.ninety:     [(-1,0), (0, 0), (0, 1), (1, 1)],
            Orientation.oneEighty:  [(1, 0), (1, 1), (0, 1), (0, 2)],
            Orientation.twoSeventy: [(-1,0), (0, 0), (0, 1), (1, 1)]
            ]
    }
    
    override var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [
            Orientation.zero:       [blocks[SecondBlockIndex], blocks[FourthBlockIndex]],
            Orientation.ninety:     [blocks[FirstBlockIndex], blocks[ThirdBlockIndex], blocks[FourthBlockIndex]],
            Orientation.oneEighty:  [blocks[SecondBlockIndex], blocks[FourthBlockIndex]],
            Orientation.twoSeventy: [blocks[FirstBlockIndex], blocks[ThirdBlockIndex], blocks[FourthBlockIndex]]
            ]
    }
}
