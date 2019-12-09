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
    
    func getTestInputPart2() -> String {
         return "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5"
    }
    
    func getPermutations (from elements:[Int]) -> [[Int]] {
        var permutations:[[Int]] = []
        if elements.count == 1 {
            return [elements]
        }
        
        for element in elements {
            let rest = elements.filter({$0 != element})
            let subpermutations = getPermutations(from:rest)
            for subperm in subpermutations {
                permutations.append([element] + subperm)
            }
        }
        return permutations
    }
    
    func getPermutations() -> [[Int]] {
        let perms =  getPermutations(from:[0,1,2,3,4])
        print ("got permutations: \(perms)")
        return perms
    }
    func getPermutationsPart2() -> [[Int]] {
        let perms =  getPermutations(from:[5,6,7,8,9])
        print ("got permutations: \(perms)")
        return perms
    }

    func getTestInputPart1() -> String {
         return "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0"
    }

     func doAoCDay7Part1(with input:String) {
     
         var maxAmpResult = 0
         var bestPhaseSettings:[Int] =  []
         let intcodeStrings = input.components(separatedBy:",")
         let intcodes = intcodeStrings.compactMap({Int($0)})
         let phaseSettingPermutations = getPermutations()
         for permutation in phaseSettingPermutations
         {
             let ampio = AmplifierIOHandler(phaseSettings:permutation)
             for engines in 0...4 {
                 let intcodeEngine = IntcodeEngine(name:"\(engines)", input:intcodes)
                 intcodeEngine.ioHandler = ampio
                 intcodeEngine.run()
            }
             guard let ampResult = ampio.currentSignal else {
                 print ("no amp result")
                 return
             }
             print ("got amp result \(ampResult)")
             if (ampResult > maxAmpResult) {
                 print ("got better amp result \(ampResult) with permutations: \(permutation)")
                 maxAmpResult = ampResult
                 bestPhaseSettings = permutation
             }

         }
         print ("best amp result \(maxAmpResult) with permutations: \(bestPhaseSettings)")
     }

     
     func doAoCDay7Part2(with input:String) {
     
         var maxAmpResult = 0
         var bestPhaseSettings:[Int] =  []
         let intcodeStrings = input.components(separatedBy:",")
         let intcodes = intcodeStrings.compactMap({Int($0)})
         let phaseSettingPermutations = getPermutationsPart2()
         for permutation in phaseSettingPermutations
         {
             var amplifiers:[AmplifierPart2IOHandler] = []
             var engines:[IntcodeEngine] = []
             let dispatchGroup = DispatchGroup()
               
              for ampIndex in 0...4 {
                  let ampio = AmplifierPart2IOHandler(phaseSetting:permutation[ampIndex])
                  if (ampIndex != 0) {
                     amplifiers[ampIndex-1].outputAmp = ampio
                  }
                  amplifiers.append(ampio)
              }
              amplifiers[4].outputAmp = amplifiers[0]
              amplifiers[0].currentSignal = 0
               
              for engineIndex in 0...4 {
                 let intcodeEngine = IntcodeEngine(name:"\(engines)", input:intcodes)
                 engines.append(intcodeEngine)
                 intcodeEngine.ioHandler = amplifiers[engineIndex]
                 dispatchGroup.enter()
                 intcodeEngine.runAsync(completion: { dispatchGroup.leave()})
             }
             dispatchGroup.wait()
             
             guard let ampResult = amplifiers[0].currentSignal else {
                 print ("no amp result")
                 return
             }
             print ("got amp result \(ampResult)")
             if (ampResult > maxAmpResult) {
                 print ("got better amp result \(ampResult) with permutations: \(permutation)")
                 maxAmpResult = ampResult
                 bestPhaseSettings = permutation
             }

         }
         print ("best amp result \(maxAmpResult) with permutations: \(bestPhaseSettings)")
     }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay7Part1(with:trimmedInput)
     }

     func testAoCPart1() {
         let input = getTestInputPart1()
         doAoCDay7Part1(with:input)
     }

    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay7Part2(with:trimmedInput)
    }

    func testAoCPart2() {
        let input = getTestInputPart2()
        doAoCDay7Part2(with:input)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
           //testAoCPart1()
           //doAoCPart1()
          //testAoCPart2()
           doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

