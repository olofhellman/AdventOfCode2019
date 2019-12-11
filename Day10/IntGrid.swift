//
//  BoolGrid.swift
//  AOC2018
//
//  Created by olof on 12/13/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

class IntGrid {
    var gridPoints:[[Int]]
    let size:Size
    
    init(x:Int, y:Int) {
        self.size = Size(dx:x, dy:y)
        self.gridPoints = []
        if (y > 0 && x > 0) {
            for _ in 0...y-1 {
                let gridLine:[Int] = Array(repeating: 0, count: x)
                self.gridPoints.append(gridLine)
            }
        }
    }
    class func spewString(_ val: Int) -> String {
       guard (val >= 0) && (val <= 999) else { return " ?? " }
       if ( val < 10) {
           return "  \(val) "
        } else if ( val < 100 ){
            return " \(val) "
        } else  {
            return " \(val)"
        }
    }
    
    func setValue(at pos:Position, to newValue:Int) {
       guard (pos.x >= 0) && (pos.x < size.dx) && (pos.y >= 0) && (pos.y < size.dy) else { return }
       gridPoints[pos.y][pos.x] = newValue
    }
    
    func getValue(at pos:Position) -> Int {
       guard (pos.x >= 0) && (pos.x < size.dx) && (pos.y >= 0) && (pos.y < size.dy) else { return 0 }
       return gridPoints[pos.y][pos.x]
    }
    
    func spew() {
        for y in 0...size.dy-1 {
            let str:String = gridPoints[y].reduce ("", {$0 + IntGrid.spewString($1)})
            print(str)
        }
    }
    
    func maxVal() -> Int {
        var bestVal = -9999999
        for y in 0...size.dy-1 {
            for x in 0...size.dx-1 {
                let val = getValue(at:Position(x:x, y:y))
                if val > bestVal {
                    bestVal = val
                }
            }
        }
        return bestVal
    }

    func maxValAndPos() -> (Int, Position) {
        var bestVal = -9999999
        var bestPos = Position(x:-1, y:-1)
        for y in 0...size.dy-1 {
            for x in 0...size.dx-1 {
                let val = getValue(at:Position(x:x, y:y))
                if val > bestVal {
                    bestVal = val
                    bestPos = Position(x:x, y:y)
                }
            }
        }
        return (bestVal, bestPos)
    }
}
