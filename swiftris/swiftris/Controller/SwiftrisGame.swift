//
//  SwiftrisGame.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/21/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

let TotalColumns = 10
let TotalRows = 20

let StartingColumn = 4
let StartingRow = 0

let PreviewColumn = 12
let PreviewRow = 1


class SwiftrisGame {
    
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    
    
    
    // MARK: - Initialization
    
    init() {
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(rows: TotalRows, columns: TotalColumns)
    }
    
    
    
    // MARK: - Game Logic
    
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
    }
    
    
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        return (fallingShape, nextShape)
    }
}
