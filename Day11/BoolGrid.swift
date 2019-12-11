//
//  BoolGrid.swift
//  AOC2018
//
//  Created by olof on 12/13/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class BoolGrid {
    var gridPoints:[[Bool]]
    let size:Size
    
    init(x:Int, y:Int) {
        self.size = Size(dx:x, dy:y)
        self.gridPoints = []
        if (y > 0 && x > 0) {
            for _ in 0...y-1 {
                let gridLine:[Bool] = Array(repeating: false, count: x)
                self.gridPoints.append(gridLine)
            }
        }
    }
    
    func copy() -> BoolGrid {
       let theCopy = BoolGrid(x:self.size.dx, y:self.size.dy)
       for y in 0...size.dy-1 {
          for x in 0...size.dx-1 {
             let pos = Position(x:x, y:y)
             if (self.isMarked(at:pos)) {
                theCopy.mark(position:pos)
             }
          }
       }
       return theCopy
    }

    
    func countMarks() -> Int {
       var c = 0
       for y in 0...size.dy-1 {
          for x in 0...size.dx-1 {
             let pos = Position(x:x, y:y)
             if (self.isMarked(at:pos)) {
                c = c + 1
             }
          }
       }
       return c
    }

    func mark(position:Position) {
       guard (position.x >= 0) && (position.x < size.dx) && (position.y >= 0) && (position.y < size.dy) else { return }
       gridPoints[position.y][position.x] = true
    }
    
    func unmark(position:Position) {
       guard (position.x >= 0) && (position.x < size.dx) && (position.y >= 0) && (position.y < size.dy) else { return }
       gridPoints[position.y][position.x] = false
    }

    func isMarked(at position:Position) -> Bool {
       guard (position.x >= 0) && (position.x < size.dx) && (position.y >= 0) && (position.y < size.dy) else { return false }
       return gridPoints[position.y][position.x]
    }

    func spew() {
        for y in 0...size.dy-1 {
            let str:String = gridPoints[y].reduce ("", {$0 + ($1 ? "x" : " ")})
            print(str)
        }
    }
}
