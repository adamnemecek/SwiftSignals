//
//  Chord.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

class Chord {
    
    var notes: [Int]?
    var scale: Scale?
    
    init (notes: Int...) {
        self.notes = notes
    }
    
    init(scale: Scale) {
        self.scale = scale
    }
}