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

    func countZeros(in s:String) -> Int {
        return s.filter { $0 == "0" }.count
    }

    func doAoCDay8Part1(with input:String) {
        let numlayers = input.count / 150
        var layers:[String] = []
        for n in 0...(numlayers - 1) {
           let low = 0 + (n * 150)
           let high = low + 149
           let layerCode = String(input[low...high])
           layers.append(layerCode)
        }
        
        let zeroCounts = layers.map({countZeros(in: $0)})
        var bestLayer = 0
        var bestZeroCount = 200
        var n = 0
        for c in zeroCounts {
            if ( c < bestZeroCount ) {
               bestLayer = n
               bestZeroCount = c
            }
            n = n + 1
        }
         
        print ("best layer is \(bestLayer) ")
        let numOnes = layers[bestLayer].filter { $0 == "1" }.count
        print (" layer \(bestLayer) has \(numOnes) ones ")
        let numTwos = layers[bestLayer].filter { $0 == "2" }.count
        print (" layer \(bestLayer) has \(numTwos) twos ")
        let prod = numOnes * numTwos
        print (" prod is \(prod)  ")  
    }

     func doAoCDay8Part2(with input:String) {
         let numlayers = input.count / 150
         var layers:[PixelGrid] = []
         for n in 0...(numlayers - 1) {
            let low = 0 + (n * 150)
            let high = low + 149
            let layerCode = String(input[low...high])
            let pixelGrid = PixelGrid(size:Size(dx:150,dy:6))
            let (resultLayer, _) = layerCode.reduce(into:(pixelGrid, 0), { (tuple, nthCharacter) in
                let (grid, n) = tuple
                let x = n%25
                let y = n/25
                let alpha = nthCharacter != "2"
                let pixVal = Int(String(nthCharacter)) ?? 0
                let pixel = Pixel(pixVal, alpha:alpha)
                grid.setPixelAt(x:x, y:y, to:pixel)
                tuple.1 = tuple.1 + 1
             })
             layers.append(resultLayer)
         }
         
         var composite = layers[0]
         for n in 1...(numlayers - 1) {
           composite = composite.draw(on:layers[n])
         }

         composite.display()
     }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay8Part1(with:trimmedInput)
     }

    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay8Part2(with:trimmedInput)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
           doAoCPart1()
           doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

