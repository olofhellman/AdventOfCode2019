//
//  Grid.swift
//  AOC2018
//
//  Created by olof on 12/5/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

struct GridContents {

   let contents:Bool?

   init( ) {
      self.contents = nil
   }
}

struct GridItem {
   let label:String
   let contents:GridContents?

   init(_ label:String) {
      self.label = label
      self.contents = nil
   }
}

class Grid {
    var rows:[[GridItem]]
    let size:Size
    
    let unoccupied = GridItem("")
    init(size:Size) {
        self.size = size
        self.rows = []
        if (size.dy > 0 && size.dx > 0) {
            for _ in 0...size.dy-1 {
                let row:[GridItem] = Array(repeating: unoccupied, count: size.dx)
                self.rows.append(row)
            }
        }
    }
 
    func setGridItemAt(x:Int, y:Int, item:GridItem) {
         rows[y][x] = item
    }
 
    func gridItemAt(x:Int, y:Int) -> GridItem {
         return rows[y][x]
    }
 
    func spew() {
        for y in 0...size.dy-1 {
            var cat = ""
            for x in 0...size.dx-1 {
                let current = gridItemAt(x:x, y:y)
                cat = cat +  "\(current.label)   "
            }
            print ("\(cat)")
        }
    }
}
