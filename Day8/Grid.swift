import Foundation

struct Pixel {
   let pixelValue:Int
   let alpha:Bool

   init(_ pixelValue:Int, alpha:Bool) {
       self.pixelValue = pixelValue
       self.alpha = alpha
   }
   
   var displayString: String {
     get {
          return pixelValue == 0 ? " " : "\(self.lastHexChar)"
       }
     }
    var lastHexChar: String {
      get {
           let val16 = pixelValue%16
           if ((val16 >= 0) && (val16 <= 9)) {
              return String(val16)
           } else {
              switch (val16) {
                  case 10:
                     return "A"
                  case 11:
                     return "B"
                  case 12:
                     return "C"
                  case 13:
                     return "D"
                  case 14:
                     return "E"
                  case 15:
                     return "F"
                  default:
                     print("something wrong")
                     return " "
              }
          }
      }
   }
}

class PixelGrid {
    var rows:[[Pixel]]
    let size:Size

    init(size:Size, initialPixel:Pixel? = nil) {
        let usePixel = initialPixel ?? Pixel(0, alpha:true)
 
        self.size = size
        self.rows = []
        if (size.dy > 0 && size.dx > 0) {
            for _ in 0...size.dy-1 {
                let row:[Pixel] = Array(repeating:usePixel, count: size.dx)
                self.rows.append(row)
            }
        }
    }
 
    class func whiteGrid(size:Size) -> PixelGrid {
       return PixelGrid(size:size, initialPixel:Pixel(0, alpha:true))
    }

    class func blackGrid(size:Size) -> PixelGrid {
       return PixelGrid(size:size, initialPixel:Pixel(1, alpha:true))
    }
    
    class func transparentGrid(size:Size) -> PixelGrid {
          return PixelGrid(size:size, initialPixel:Pixel(0, alpha:false))
    }

    func setPixelAt(x:Int, y:Int, to item:Pixel) {
        guard (x <= size.dx) && (x >= 0) && (y <= size.dy) && (y >= 0) else {
            return
        }
        rows[y][x] = item
    }
 
    func pixelAt(x:Int, y:Int) -> Pixel {
        guard (x <= size.dx) && (x >= 0) && (y <= size.dy) && (y >= 0) else {
            return Pixel(0, alpha:true)
        }
        return rows[y][x]
    }
        
    func draw(on canvas:PixelGrid) -> PixelGrid {
        let pixelGrid = PixelGrid.transparentGrid(size:canvas.size)
        for x in 0...(canvas.size.dx-1) {
            for y in 0...(canvas.size.dy-1) {
               var canvasPixel = canvas.pixelAt(x:x, y:y)
               let drawPixel = self.pixelAt(x:x, y:y)
               if drawPixel.alpha {
                  canvasPixel = drawPixel
               }
               pixelGrid.setPixelAt(x:x, y:y, to:canvasPixel)
            }
        }
        return pixelGrid
    }
 
    func display() {
        for y in 0...size.dy-1 {
            var cat = ""
            for x in 0...size.dx-1 {
                let current = pixelAt(x:x, y:y)
                cat.append(current.displayString)
            }
            print ("\(cat)")
        }
    }
}
