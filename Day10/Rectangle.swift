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

struct Rectangle{
    let id:Int
    let size:Size
    let position:Position
    
    var firsty:Int {
       get {
           return position.y
       }
    }
    var lasty:Int {
       get {
           return position.y + size.dy - 1
       }
    }
    var firstx:Int {
       get {
           return position.x
       }
    }
    var lastx:Int {
       get {
           return position.x + size.dx - 1
       }
    }
    var area:Int {
       get {
           return size.dx * size.dy
       }
    }
    init(id:Int, size:Size, position:Position) {
        self.id = id
        self.size = size
        self.position = position
    }
    
    init?(token:String) {
        // format is #123 @ 3,2: 5x4
        let splits = token.split(separator:"@", maxSplits:1, omittingEmptySubsequences:false)
        guard splits.count == 2 else { print ("error creating Rect from \(token)"); return nil }
        guard splits[0].count > 2 else { print ("first split of \(token) was \(splits[0])"); return nil }
         
        let idstr =  splits[0].dropFirst().dropLast()
        guard let idval = Int(idstr) else { print ("can't make Int from \(idstr)"); return nil }
        self.id = idval
        
        let posAndSize  = splits[1].split(separator:":", maxSplits:1, omittingEmptySubsequences:false)
        let posStr = posAndSize[0].dropFirst()
        let sizeStr = posAndSize[1].dropFirst()
        guard posStr.count > 2 else { print ("first split of \(splits[1]) was \(posStr[0])"); return nil }
        guard sizeStr.count > 2 else { print ("second split of \(splits[1]) was \(posStr[1])"); return nil }
        
        let xandy = posStr.split(separator:",", maxSplits:1, omittingEmptySubsequences:false)
        guard xandy[0].count > 0 else { print ("first split of \(posStr) was \(xandy[0])"); return nil }
        guard xandy[1].count > 0 else { print ("second split of \(posStr) was \(xandy[1])"); return nil }
        
        let dzanddy = sizeStr.split(separator:"x", maxSplits:1, omittingEmptySubsequences:false)
        guard dzanddy[0].count > 0 else { print ("first split of \(sizeStr) was \(dzanddy[0])"); return nil }
        guard dzanddy[1].count > 0 else { print ("second split of \(sizeStr) was \(dzanddy[1])"); return nil }

        guard let x = Int(xandy[0]) else { print ("can't make Int from \(xandy[0])"); return nil }
        guard let y = Int(xandy[1]) else { print ("can't make Int from \(xandy[1])"); return nil }
        guard let dx = Int(dzanddy[0]) else { print ("can't make Int from \(dzanddy[0])"); return nil }
        guard let dy = Int(dzanddy[1]) else { print ("can't make Int from \(dzanddy[1])"); return nil }
        self.size = Size(dx:dx, dy:dy)
        self.position = Position(x:x, y:y)
    }
}
