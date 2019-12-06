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
         return """
         COM)B
         D)E
         B)C
         C)D
         E)F
         B)G
         G)H
         D)I
         E)J
         J)K
         K)L
         K)YOU
         I)SAN
         """
    }

    func getTestInputPart1() -> String {
         return """
         COM)B
         D)E
         B)C
         C)D
         E)F
         B)G
         G)H
         D)I
         E)J
         J)K
         K)L
         """
    }

    func makeOrbiterTree(with input:String) -> OrbiterTree {
        let lines = input.components(separatedBy:"\n")
        let orbits = lines.compactMap({Orbit($0)})
        return OrbiterTree(orbits:orbits)
    }

     func doAoCDay6Part1(with input:String) {
         let orbiterTree = makeOrbiterTree(with:input)
         let orbitCount = orbiterTree.countOrbits()
         print ("there are \(orbitCount) orbits")
     }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay6Part1(with:trimmedInput)
     }

     func testAoCPart1() {
         let input = getTestInputPart1()
         doAoCDay6Part1(with:input)
     }

    func doAoCDay6Part2(with input:String) {
        let orbiterTree = makeOrbiterTree(with:input)
        let jumpCount = orbiterTree.countJumps(from:"YOU", to:"SAN")
        print ("there are \(jumpCount) jumps")
    }
    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay6Part2(with:trimmedInput)
    }

    func testAoCPart2() {
        let input = getTestInputPart2()
        doAoCDay6Part2(with:input)
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

