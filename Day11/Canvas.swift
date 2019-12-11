import Foundation

class Canvas {
    var pixelDictionary:[String:Pixel]
    var unlistedPixel:Pixel

    init(initialPixel:Pixel? = nil) {
        self.unlistedPixel = initialPixel ?? Pixel(0, alpha:true)
        self.pixelDictionary = [:]
    }
    
    private func positionFrom(key:String) -> Position? {
       let tokens = key.components(separatedBy: ",")
       guard tokens.count == 2 else { return nil }
       guard let x = Int(tokens[0]) else { return nil }
       guard let y = Int(tokens[1]) else { return nil }
       return Position(x:x, y:y)
    }
    
    private func keyFor(position:Position) -> String {
       return "\(position.x),\(position.y)"
    }

    public func setPixelAt(position:Position, to pixel:Pixel) {
       let key = keyFor(position:position)
       pixelDictionary[key] = pixel
    }

     public func setPixelAt(x:Int, y:Int, to pixel:Pixel) {
        self.setPixelAt(position:Position(x:x, y:y), to:pixel)
     }
    
    public func pixelAt(position:Position) -> Pixel {
       let key = keyFor(position:position)
       return pixelDictionary[key] ?? unlistedPixel
    }
    
    public func pixelAt(x:Int, y:Int) -> Pixel {
       return self.pixelAt(position:Position(x:x, y:y))
    }

    func getDimensions() -> (Position, Size) {
        guard let (firstKey, _) = pixelDictionary.first else {
            return (Position(x:0,y:0), Size(dx:0, dy:0))
        }
        var minx = 0
        var maxx = 0
        var miny = 0
        var maxy = 0
        if let pos = positionFrom(key:firstKey) {
             minx = pos.x
             maxx = pos.x
             miny = pos.y
             maxy = pos.y
        }
        for (key,_) in pixelDictionary {
            if let pos = positionFrom(key:key) {
                if (pos.x < minx) {
                    minx = pos.x
                }
                if (pos.x > maxx) {
                    maxx = pos.x
                }
                if (pos.y < miny) {
                    miny = pos.y
                }
                if (pos.y > maxy) {
                    maxy = pos.y
                }
            }
        }
        let upperRight = Position(x:minx,y:miny)
        let dims = Size(dx:(maxx-minx)+1, dy:(maxy-miny)+1)
        return (upperRight, dims)
    }
    
    func pixelGrid() -> PixelGrid {
        let (upperRight, dimensions) = self.getDimensions()
        let grid = PixelGrid(size:dimensions, initialPixel:unlistedPixel)
        for (key,pixel) in pixelDictionary {
            if let pos = positionFrom(key:key) {
               let gridPos = Position(x:pos.x + upperRight.x, y:pos.y + upperRight.y)
               grid.setPixelAt(position:gridPos, to:pixel)
            }
        }
        return grid
    }
    func countPixels() -> Int {
        return pixelDictionary.count
    }
    
    func display() {
        let pixelGrid = self.pixelGrid()
        pixelGrid.display()
    }
    
}
