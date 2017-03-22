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

let PointsPerLine = 10
let LevelThreshold = 1000


// GB - Enforces the rules of the Tetris game; checks for things like collisions etc

protocol SwiftrisGameDelegate {
    // Invoked when the current round of Swiftris ends
    func gameDidEnd(_ swiftris: SwiftrisGame)
    
    // Invoked immediately after a new game has begun
    func gameDidBegin(_ swiftris: SwiftrisGame)
    
    // Invoked when the falling shape has become part of the game board
    func gameShapeDidLand(_ swiftris: SwiftrisGame)
    
    // Invoked when the falling shape has changed its location
    func gameShapeDidMove(_ swiftris: SwiftrisGame)
    
    // Invoked when the falling shape has changed its location after being dropped
    func gameShapeDidDrop(_ swiftris: SwiftrisGame)
    
    // Invoked when the game has reached a new level
    func gameDidLevelUp(_ swiftris: SwiftrisGame)
}


class SwiftrisGame {
    
    var blockArray:Array2D<Block>
    var nextShape:Shape?
    var fallingShape:Shape?
    var delegate:SwiftrisGameDelegate?
    
    var score:Int
    var level:Int
    
    
    // MARK: - Initialization
    
    init() {
        score = 0
        level = 1
        fallingShape = nil
        nextShape = nil
        blockArray = Array2D<Block>(rows: TotalRows, columns: TotalColumns)
    }

    // MARK: - Game Logic
    
    func beginGame() {
        if (nextShape == nil) {
            nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        }
        
        delegate?.gameDidBegin(self)
    }
    
    
    func endGame() {
        delegate?.gameDidEnd(self)
        score = 0
        level = 1
    }
    
    
    
    func newShape() -> (fallingShape:Shape?, nextShape:Shape?) {
        fallingShape = nextShape
        nextShape = Shape.random(PreviewColumn, startingRow: PreviewRow)
        fallingShape?.moveTo(StartingColumn, row: StartingRow)
        
        if detectIllegalPlacement() {
            nextShape = fallingShape
            nextShape!.moveTo(PreviewColumn, row: PreviewRow)
            endGame()
            return (nil, nil)
        }
        
        return (fallingShape, nextShape)
    }
    
    
    func detectIllegalPlacement() -> Bool {
        if let shape = fallingShape {
            for block in shape.blocks {
                if block.column < 0 || block.column >= TotalColumns
                    || block.row < 0 || block.row >= TotalRows {
                        return true
                } else if blockArray[block.column, block.row] != nil {
                    return true
                }
            }
        }
        return false
    }
    
    
    func dropShape() {
        if let shape = fallingShape {
            while detectIllegalPlacement() == false {
                shape.lowerShapeByOneRow()
            }
            shape.raiseShapeByOneRow()
            delegate?.gameShapeDidDrop(self)
        }
    }

    
    func letShapeFall() {
        if let shape = fallingShape {
            shape.lowerShapeByOneRow()
            if detectIllegalPlacement() {
                shape.raiseShapeByOneRow()
                if detectIllegalPlacement() {
                    endGame()
                } else {
                    settleShape()
                }
            } else {
                delegate?.gameShapeDidMove(self)
                if detectTouch() {
                    settleShape()
                }
            }
        }
    }
    
    
    func rotateShape() {
        if let shape = fallingShape {
            shape.rotateClockwise()
            if detectIllegalPlacement() {
                shape.rotateCounterClockwise()
            } else {
                delegate?.gameShapeDidMove(self)
            }
        }
    }
    

    func moveShapeLeft() {
        if let shape = fallingShape {
            shape.shiftLeftByOneColumn()
            if detectIllegalPlacement() {
                shape.shiftRightByOneColumn()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
    
    func moveShapeRight() {
        if let shape = fallingShape {
            shape.shiftRightByOneColumn()
            if detectIllegalPlacement() {
                shape.shiftLeftByOneColumn()
                return
            }
            delegate?.gameShapeDidMove(self)
        }
    }
    
    
    func settleShape() {
        if let shape = fallingShape {
            for block in shape.blocks {
                blockArray[block.column, block.row] = block
            }
            fallingShape = nil
            delegate?.gameShapeDidLand(self)
        }
    }
    

    func detectTouch() -> Bool {
        if let shape = fallingShape {
            for bottomBlock in shape.bottomBlocks {
                if bottomBlock.row == TotalRows - 1 ||
                    blockArray[bottomBlock.column, bottomBlock.row + 1] != nil {
                        return true
                }
            }
        }
        return false
    }
    

    func removeCompletedLines() -> (linesRemoved: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>) {
        var removedLines = Array<Array<Block>>()
        for row in ((0 + 1)...TotalRows - 1).reversed() {
            var rowOfBlocks = [Block]()

            for column in 0..<TotalColumns {
                if let block = blockArray[column, row] {
                    rowOfBlocks.append(block)
                }
            }
            if rowOfBlocks.count == TotalColumns {
                removedLines.append(rowOfBlocks)
                for block in rowOfBlocks {
                    blockArray[block.column, block.row] = nil
                }
            }
        }
        
        if removedLines.count == 0 {
            return ([], [])
        }

        let pointsEarned = removedLines.count * PointsPerLine * level
        score += pointsEarned
        if score >= level * LevelThreshold {
            level += 1
            delegate?.gameDidLevelUp(self)
        }
        
        var fallenBlocks = Array<Array<Block>>()
        for column in 0..<TotalColumns {
            var fallenBlocksArray = Array<Block>()
            // #5
            for row in ((0 + 1)...removedLines[0][0].row - 1).reversed() {
                if let block = blockArray[column, row] {
                    var newRow = row
                    while (newRow < TotalRows - 1 && blockArray[column, newRow + 1] == nil) {
                        newRow += 1
                    }
                    block.row = newRow
                    blockArray[column, row] = nil
                    blockArray[column, newRow] = block
                    fallenBlocksArray.append(block)
                }
            }
            
            if fallenBlocksArray.count > 0 {
                fallenBlocks.append(fallenBlocksArray)
            }
        }
        return (removedLines, fallenBlocks)
    }
    
    
    func removeAllBlocks() -> Array<Array<Block>> {
        var allBlocks = Array<Array<Block>>()
        for row in 0..<TotalRows {
            var rowOfBlocks = Array<Block>()
            for column in 0..<TotalColumns {
                if let block = blockArray[column, row] {
                    rowOfBlocks.append(block)
                    blockArray[column, row] = nil
                }
            }
            allBlocks.append(rowOfBlocks)
        }
        return allBlocks
    }
    


    
    
}
