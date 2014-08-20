//
//  Block.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import SpriteKit

let NumberOfColors: UInt32 = 6;

enum BlockColor: Int, Printable {
   
    case Blue = 0, Orange, Purple, Red, Teal, Yellow
    
    
    // MARK: - Printable

    var spriteName: String {
        
        switch self {
        case .Blue:
            return "blue"
        case .Orange:
            return "orange"
        case .Purple:
            return "purple"
        case .Red:
            return "red"
        case .Teal:
            return "teal"
        case .Yellow:
            return "yellow"
            }
    }
    
    var description: String { // GB - this is known as a 'computed property'
        return self.spriteName
    }
    
    
    // MARK: - Other
    
    static func random() -> BlockColor {
        // GB - This is an odd way to get a random number, but OK
        return BlockColor.fromRaw(Int(arc4random_uniform(NumberOfColors)))!
    }
    
}


class Block: Hashable, Printable {
    
    let color: BlockColor
    
    var column: Int
    var row: Int
    var sprite: SKSpriteNode?
    
    // GB - Another 'computed property'
    var spriteName: String {
        return color.spriteName // GB - could have also used 'color.description'
    }
    
    var hashValue: Int {
        return row ^ column
    }
    
    var description: String {
        return "\(color) \(column) \(row)"
    }
    
    
    // MARK: - Initialization
    
    init(column:Int, row:Int, color:BlockColor) {
        self.column = column
        self.row = row
        self.color = color
    }
}


func ==(lhs: Block, rhs: Block) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row && lhs.color.toRaw() == rhs.color.toRaw()
}

