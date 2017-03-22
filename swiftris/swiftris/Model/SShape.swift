//
//  SShape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

class SShape:Shape {
    /*
    
    Orientation 0
    
    | 0•|
    | 1 | 2 |
    | 3 |
    
    Orientation 90
    
    • | 1 | 0 |
    | 3 | 2 |
    
    Orientation 180
    
    | 0•|
    | 1 | 2 |
    | 3 |
    
    Orientation 270
    
    • | 1 | 0 |
    | 3 | 2 |
    
    • marks the row/column indicator for the shape
    
    */
    
    override var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [
            Orientation.zero:       [(0, 0), (0, 1), (1, 1), (1, 2)],
            Orientation.ninety:     [(2, 0), (1, 0), (1, 1), (0, 1)],
            Orientation.oneEighty:  [(0, 0), (0, 1), (1, 1), (1, 2)],
            Orientation.twoSeventy: [(2, 0), (1, 0), (1, 1), (0, 1)]
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
