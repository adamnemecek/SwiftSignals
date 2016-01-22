//
//  Geometry.swift
//  SwiftAudio
//
//  Created by Danny van Swieten on 1/13/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

struct Position {
    var x: Float = 0.0
    var y: Float = 0.0
}

struct Size {
    var width: Float    = 0.0
    var height: Float   = 0.0
}

struct Rectangle {
    var position    = Position()
    var size        = Size()
    
    func isPointWithinRectangle(p: Position) -> Bool {
        let xMatch = p.x > self.position.x && p.x < self.position.x + self.size.width
        let yMatch = p.y > self.position.y && p.y < self.position.y + self.size.height
        
        return xMatch == true && yMatch == true
    }
}

func /(var lhs: Rectangle, rhs: Float) -> Rectangle {
    lhs.size.width  /= rhs
    lhs.size.height /= rhs
    return lhs
}

func -(lhs: Position, rhs: Position) -> Position {
    let point = Position(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    return point
}

func +(var lhs: Position, rhs: Position) -> Position {
    lhs.x += rhs.x
    lhs.y += rhs.y
    return lhs
}