//: Playground - noun: a place where people can play

import Cocoa

func foo(x: Int?) -> Void {
    print(x?.advancedBy(1))
}

var number: Int? = 9

foo(number)