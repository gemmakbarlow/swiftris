//
//  Array2D.swift
//  swiftris
//
//  Created by Gemma Barlow on 8/20/14.
//  Copyright (c) 2014 Gemma Barlow. All rights reserved.
//

import Foundation

// GB - Class denoting a 2D Data Model type

class Array2D<T>  {
 
    let rows: Int
    let columns: Int
    
    var array: Array<T?>
    
    
    // MARK: - Initialization
    
    init(rows: Int, columns: Int) {
        self.rows = rows;
        self.columns = columns;
        array = Array<T?>(count:rows * columns, repeatedValue: nil)
    }
    
    
    
    // MARK: - Other
    
    subscript(row: Int, column: Int) -> T? {

        get {
            return array[(row * columns) + column]
        }
        
        set(newValue)  {
            array[(row * columns) + column] = newValue
        }
    }

}
