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

    func getTestInputPart1() -> String {
          return "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
         // return "1102,34915192,34915192,7,4,7,99,0"
         // return "104,1125899906842624,99"
    }

    func countZeros(in s:String) -> Int {
        return s.filter { $0 == "0" }.count
    }

     func doAoCDay9Part1(with input:String) {
        let intcodeStrings = input.components(separatedBy:",")
        let intcodes = intcodeStrings.compactMap({Int($0)})
        let engine = IntcodeEngine(name:"engine", input:intcodes)
        engine.ioHandler = TESTDiagnosticDay9Part1IOHandler()
        engine.run()
     }

     
     func doAoCDay9Part2(with input:String) {
        let intcodeStrings = input.components(separatedBy:",")
        let intcodes = intcodeStrings.compactMap({Int($0)})
        let engine = IntcodeEngine(name:"engine", input:intcodes)
        engine.ioHandler = TESTDiagnosticDay9Part2IOHandler()
        engine.run()
     }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay9Part1(with:trimmedInput)
     }

     func testAoCPart1() {
         let input = getTestInputPart1()
         let intcodeStrings = input.components(separatedBy:",")
         let intcodes = intcodeStrings.compactMap({Int($0)})
         let engine = IntcodeEngine(name:"engine", input:intcodes)
         engine.ioHandler = TESTDiagnosticDay9Part1IOHandler()
         engine.run()
        //  doAoCDay9Part1(with:input)
     }

    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay9Part2(with:trimmedInput)
    }

    func testAoCPart2() {
        let input = getTestInputPart2()
        doAoCDay9Part2(with:input)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
           testAoCPart1()
           doAoCPart1()
          testAoCPart2()
          doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

