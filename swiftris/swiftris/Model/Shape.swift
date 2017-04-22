//
//  Shape.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import SpriteKit


// MARK: - Orientation

let OrientationsCount: UInt32 = 4

enum Orientation: Int, CustomStringConvertible {
    
    case zero = 0, ninety, oneEighty, twoSeventy
    
    var description: String {
        switch self {
        case .zero:
            return "0"
        case .ninety:
            return "90"
        case .oneEighty:
            return "180"
        case .twoSeventy:
            return "270"
        }
    }
    
    static func random() -> Orientation {
        return Orientation(rawValue: Int(arc4random_uniform(OrientationsCount)))!
    }
    
    static func rotate(_ orientation:Orientation, clockwise: Bool) -> Orientation {
        var rotated = orientation.rawValue + (clockwise ? 1 : -1)
        if rotated > Orientation.twoSeventy.rawValue {
            rotated = Orientation.zero.rawValue
        } else if rotated < 0 {
            rotated = Orientation.twoSeventy.rawValue
        }
        return Orientation(rawValue: rotated)!
    }
}




// MARK: - Shape

let TotalShapeVarietiesCount: UInt32 = 7

enum BlockIndex: Int {
    case firstBlockIndex = 0, secondBlockIndex = 1, thirdBlockIndex = 2, fourthBlockIndex = 3
}

class Shape: Hashable, CustomStringConvertible {
    
    let color: BlockColor
    var blocks = Array<Block>() // GB - Blocks comprising the shape
    var currentOrientation: Orientation // GB - Current shape orientation
    var column, row:Int // GB - Current anchor point of the shape
    
    
    
    let FirstBlockIndex: Int = 0
    let SecondBlockIndex: Int = 1
    let ThirdBlockIndex: Int = 2
    let FourthBlockIndex: Int = 3
    
    // MARK: - Initialization
    
    init(column: Int, row: Int, color: BlockColor, orientation: Orientation) {
        self.column = column
        self.row = row
        self.color = color
        self.currentOrientation = orientation
        
        initializeBlocks()
    }
    
    convenience init(column:Int, row:Int) {
        self.init(column:column, row:row, color:BlockColor.random(), orientation:Orientation.random())
    }
    
    
    // MARK: - Block Manipulation
    
    final func initializeBlocks() {
        if let blockRowColumnTranslations = blockRowColumnPositions[currentOrientation] {
            for i in 0..<blockRowColumnTranslations.count {
                let blockRow = row + blockRowColumnTranslations[i].rowDiff
                let blockColumn = column + blockRowColumnTranslations[i].columnDiff
                let newBlock = Block(column: blockColumn, row: blockRow, color: color)
                blocks.append(newBlock)
            }
        }
    }
    
    
    final func rotateBlocks(_ orientation: Orientation) {
        if let blockRowColumnTranslation: Array<(columnDiff: Int, rowDiff: Int) > = blockRowColumnPositions[orientation] {
            // #1
            for (idx, element) in blockRowColumnTranslation.enumerated() {
                blocks[idx].column = column + element.columnDiff
                blocks[idx].row = row + element.rowDiff
            }
        }
    }
    
    
    final func rotateClockwise() {
        let newOrientation = Orientation.rotate(currentOrientation, clockwise: true)
        rotateBlocks(newOrientation)
        currentOrientation = newOrientation
    }
    
    final func rotateCounterClockwise() {
        let newOrientation = Orientation.rotate(currentOrientation, clockwise: false)
        rotateBlocks(newOrientation)
        currentOrientation = newOrientation
    }
    
    
    final func raiseShapeByOneRow() {
        shiftBy(0, rows:-1)
    }
    
    final func shiftRightByOneColumn() {
        shiftBy(1, rows:0)
    }
    
    final func shiftLeftByOneColumn() {
        shiftBy(-1, rows:0)
    }
    
    
    final func lowerShapeByOneRow() {
        shiftBy(0, rows:1)
    }
    

    final func shiftBy(_ columns: Int, rows: Int) {
        self.column += columns
        self.row += rows
        for block in blocks {
            block.column += columns
            block.row += rows
        }
    }
    

    final func moveTo(_ column: Int, row:Int) {
        self.column = column
        self.row = row
        rotateBlocks(currentOrientation)
    }
    
    
    final class func random(_ startingColumn:Int, startingRow:Int) -> Shape {
        switch Int(arc4random_uniform(TotalShapeVarietiesCount)) {
            case 0:
                return SquareShape(column:startingColumn, row:startingRow)
            case 1:
                return LineShape(column:startingColumn, row:startingRow)
            case 2:
                return TShape(column:startingColumn, row:startingRow)
            case 3:
                return LShape(column:startingColumn, row:startingRow)
            case 4:
                return JShape(column:startingColumn, row:startingRow)
            case 5:
                return SShape(column:startingColumn, row:startingRow)
            default:
                return ZShape(column:startingColumn, row:startingRow)
        }
    }
    
    
    // GB - Hashable
    var hashValue:Int {
        return blocks.reduce(0, { $0.hashValue ^ $1.hashValue })
    }
    
    // GB - Printable
    var description:String {
        return "\(color) block facing \(currentOrientation): \(blocks[FirstBlockIndex]), \(blocks[SecondBlockIndex]), \(blocks[ThirdBlockIndex]), \(blocks[FourthBlockIndex])"
    }
    
    
    // MARK: - Required Overrides

    var blockRowColumnPositions: [Orientation: Array<(columnDiff: Int, rowDiff: Int)>] {
        return [:] // GB - this is the sign for 'empty dictionary'!
    }

    var bottomBlocksForOrientations: [Orientation: Array<Block>] {
        return [:]
    }

    var bottomBlocks:Array<Block> {
        if let bottomBlocks = bottomBlocksForOrientations[currentOrientation] {
            return bottomBlocks
        } else {
            return []
        }
    }
    
}



// GB - Equitable (can be checked for equality)

func ==(lhs: Shape, rhs: Shape) -> Bool {
    
    return  lhs.column == rhs.column &&
            lhs.row == rhs.row &&
            lhs.color == rhs.color &&
            lhs.blocks.count == rhs.blocks.count
}
