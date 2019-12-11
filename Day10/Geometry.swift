//
//  Rectangle.swift
//  AOC2018
//
//  Created by olof on 12/5/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

struct Size {
    let dx:Int
    let dy:Int
    
    init(dx:Int,
         dy:Int) {
        
        self.dx = dx
        self.dy = dy
    }
    
    func clockwiseAngleFromUp() -> Double {
        guard dy != 0 else {
           return dx > 0 ?  (3.141592 / 2) : (3.141592 * (3 / 2))
        }
        guard dx != 0 else {
           return dy > 0 ?  (0) : (3.141592)
        }
        let cos = Double(-dy)
        let sin = Double(dx)
        let tan = sin/cos
        var angle = atan(tan)
        
        if ((cos > 0) && (sin < 0)) {
            angle +=  2 * 3.141592
        }
        else if (cos < 0) {
            angle +=  3.141592
        }
        
        return angle
    }
}

struct Position {
    let x:Int
    let y:Int
    
    init(x:Int,
         y:Int) {
        
        self.x = x
        self.y = y
    }
    
    var label:String {
        get {
            return "\(self.x),\(self.y)"
        }
    }
}

