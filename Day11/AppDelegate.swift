//
//  AppDelegate.swift
//  Advent of Code 2019
//
//  Created by olof on 12/4/18.
//

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
          return """
          .#..#
          .....
          #####
          ....#
          ...##
          """
    }

    func doAoCDay11Part1(with input:String) {
        let canvas = Canvas(initialPixel: Pixel(0, alpha:false))
        let robot = Day11Part1Robot(on:canvas)
 
        let intcodeStrings = input.components(separatedBy:",")
        let intcodes = intcodeStrings.compactMap({Int($0)})
        let intcodeEngine = IntcodeEngine(name:"day11Part1Engine", input:intcodes)
        intcodeEngine.ioHandler = robot
        intcodeEngine.run()
        
        // now, count panels in canvas
        let pixelCount = canvas.countPixels()
        print ("there are \(pixelCount) pixels")
        
    }

     
     func doAoCDay11Part2(with input:String) {
            let canvas = Canvas(initialPixel: Pixel(0, alpha:false))
            canvas.setPixelAt(x:0, y:0, to:  Pixel(1, alpha:true))
            let robot = Day11Part1Robot(on:canvas)
     
            let intcodeStrings = input.components(separatedBy:",")
            let intcodes = intcodeStrings.compactMap({Int($0)})
            let intcodeEngine = IntcodeEngine(name:"day11Part1Engine", input:intcodes)
            intcodeEngine.ioHandler = robot
            intcodeEngine.run()
            
            // now, count panels in canvas
            canvas.display()
      }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay11Part1(with:trimmedInput)
     }

     func testAoCPart1() {
         let input = getTestInputPart1()
         doAoCDay11Part1(with:input)
     }

    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay11Part2(with:trimmedInput)
    }

    func testAoCPart2() {
        let input = getTestInputPart2()
        doAoCDay11Part2(with:input)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //testAoCPart1()
        // doAoCPart1()
          //testAoCPart2()
        doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

