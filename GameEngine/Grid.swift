//
//  Grid.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/15/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Grid<T: Arithmetic> {
    
    var data: UnsafeMutablePointer<T>?
    var size = 0
    
    init(aSize: Int) {
        size = aSize
        data = UnsafeMutablePointer<T>.alloc(size * size)
    }
    
    deinit {
        data?.destroy()
    }
    
    subscript(row: Int) -> UnsafeMutablePointer<T> {
            return data!.advancedBy(row * size)
    }
}

func heightMap(size: Int, initialValue: Float) -> Grid<Float>{
    let grid = Grid<Float>(aSize: size)
    
    grid[0][0] = fmodf(Float(rand()), 1.0)
    grid[0][size] = fmodf(Float(rand()), 1.0)
    grid[size][size] = fmodf(Float(rand()), 1.0)
    grid[size][0] = fmodf(Float(rand()), 1.0)
    
    return grid
}