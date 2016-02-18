//
//  Scale.swift
//  SwiftEngine
//
//  Created by Danny van Swieten on 2/18/16.
//  Copyright © 2016 Danny van Swieten. All rights reserved.
//

import Foundation

enum Degree: String {
    case First      = "I"
    case Second     = "ii"
    case Third      = "iii"
    case Fourth     = "IV"
    case Fifth      = "V"
    case Sixth      = "vi"
    case Seventh    = "vii"
}

class Scale {
    
    var notes   = [Int]()
    var root    = 0
    
    init(notes: Int...) {
        self.notes = notes
    }
    
    subscript(degree: String) -> Chord {
        
        guard let d = Degree(rawValue: degree) else {
            return Chord(notes: 0)
        }
        
        switch(d) {
        case .First:
            return Chord(notes: notes[root], notes[(2 + root) % 7], notes[(4 + root) % 7])
            
        case .Second:
            let offset = root + 1
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
            
        case .Third:
            let offset = root + 2
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
            
        case .Fourth:
            let offset = root + 3
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
            
        case .Fifth:
            let offset = root + 4
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
            
        case .Sixth:
            let offset = root + 5
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
            
        case .Seventh:
            let offset = root + 6
            return Chord(notes: notes[offset], notes[(2 + offset) % 7], notes[(4 + offset) % 7])
        }
    }
}

class MajorScale: Scale {
    
    init() {
        super.init(notes: 0, 2, 4, 5, 7, 9, 11)
    }
    
    func toMajor() {
        root = 0
    }
    
    func toDorian() {
        root = 1
    }
    
    func toPhrygian() {
        root = 2
    }
    
    func toLydian() {
        root = 3
    }
    
    func toMixolydian() {
        root = 4
    }
    
    func toAeolian() {
        root = 5
    }
    
    func toLocrian() {
        root = 6
    }
}