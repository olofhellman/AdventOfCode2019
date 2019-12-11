import Foundation

class PaintRobot : IOHandler {

    public var canvas:Canvas
    var position:Position
    var direction:IntVector
    var expectingColor:Bool
    var nextPixel:Pixel
    
    init(on canvas:Canvas) {
        self.canvas = canvas
        self.expectingColor = true
        self.nextPixel = Pixel(0, alpha:false)
        self.position = Position(x:0, y:0)
        self.direction = IntVector(0,-1)
    }
    
    func turnRight() {
        self.direction = self.direction.rotatedRight()
    }
    
    func turnLeft() {
        self.direction = self.direction.rotatedLeft()
    }
    
    func moveForward() {
        self.position = self.position.adding(vector:self.direction)
    }
    
    func hasNextInput() -> Bool {
        true
    }

    func getNextInput() -> Int {
        let currentPixel = canvas.pixelAt(position:self.position)
        return currentPixel.pixelValue
    }
    
    func writeOutput(_ outputValue: Int) {
        if (self.expectingColor) {
            self.nextPixel = Pixel(outputValue, alpha:true)
            canvas.setPixelAt(position:self.position, to:self.nextPixel)
        } else {
           if (outputValue == 0) {
              turnLeft()
           } else if (outputValue == 1) {
               turnRight()
           }
           moveForward()
        }
        self.expectingColor = !self.expectingColor;
    }
    
}
