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
 
     func doAoCDay5(with input:String) {
         let codes = input.components(separatedBy:",")
         let ints = codes.compactMap({Int($0)})
         let engine = IntcodeEngine(input:ints)
         engine.ioHandler = TESTDiagnosticDay5Part2IOHandler()
         engine.run()
     }

    func getTestInput() -> String {
         return "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
    }


    func doAoC() {
        let input = getInput()
        let trimmedInput = input.trimmingCharacters(in: CharacterSet(charactersIn:"\n\r"))
        doAoCDay5(with:trimmedInput)
    }

    func testAoC() {
        let input = getTestInput()
        doAoCDay5(with:input)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
          // testAoC()
         doAoC()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

