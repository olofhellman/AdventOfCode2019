import Foundation

struct IntVector {
    let x:Int
    let y:Int
    
    init(_ x:Int,
         _ y:Int) {
        
        self.x = x
        self.y = y
    }
    
    func rotatedRight() -> IntVector {
        return (IntVector(-y, x))
    }
    
    func rotatedLeft() -> IntVector {
        return (IntVector(y, -x))
    }
}

struct Size {
    let dx:Int
    let dy:Int
    
    init(dx:Int,
         dy:Int) {
        
        self.dx = dx
        self.dy = dy
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
    
    func adding(vector:IntVector) -> Position {
        return Position(x:self.x + vector.x, y:self.y + vector.y)
    }

}
