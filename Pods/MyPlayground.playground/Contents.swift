//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


let names = ["adam", "daniel", "christian"]
let nameLengths = names.map { $0.characters.count }
print(nameLengths) // "4, 6, 9"
