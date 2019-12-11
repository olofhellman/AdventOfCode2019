import Cocoa

@NSApplicationMain

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    func getInput() -> String {
        let mainBundle = Bundle.main
        guard let inputUrl = mainBundle.url(forResource:"AoCInput", withExtension:"txt") else {
            print ("error getting url")
            return ""
        }
        guard let input = try? String(contentsOf:inputUrl, encoding:String.Encoding.utf8) else {
            print ("error reading url")
            return ""
        }
        return input
    }
 
    func getTrimmedInput() -> String {
        let input = getInput()
        return input.trimmingCharacters(in: CharacterSet(charactersIn:"\n\r"))
    }

    func doAoCDay11Part1(with input:String) {
        let canvas = Canvas(initialPixel: Pixel(0, alpha:false))
        let robot = PaintRobot(on:canvas)
 
        let intcodeStrings = input.components(separatedBy:",")
        let intcodes = intcodeStrings.compactMap({Int($0)})
        let intcodeEngine = IntcodeEngine(name:"day11Engine", input:intcodes)
        intcodeEngine.ioHandler = robot
        intcodeEngine.run()
        
        // now, count panels in canvas
        let pixelCount = canvas.countPixels()
        print ("there are \(pixelCount) pixels")
        
    }

     
     func doAoCDay11Part2(with input:String) {
            let canvas = Canvas(initialPixel: Pixel(0, alpha:false))
            canvas.setPixelAt(x:0, y:0, to:  Pixel(1, alpha:true))
            let robot = PaintRobot(on:canvas)
     
            let intcodeStrings = input.components(separatedBy:",")
            let intcodes = intcodeStrings.compactMap({Int($0)})
            let intcodeEngine = IntcodeEngine(name:"day11Engine", input:intcodes)
            intcodeEngine.ioHandler = robot
            intcodeEngine.run()
            
            // now, count panels in canvas
            canvas.display()
      }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay11Part1(with:trimmedInput)
     }
    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay11Part2(with:trimmedInput)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        doAoCPart1()
        doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

