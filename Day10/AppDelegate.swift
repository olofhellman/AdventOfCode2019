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
                
    class func getBlockingVectors(for vec:Size) -> [Size] {
        var blockerList:[Size] = []
        let posx = abs(vec.dx)
        let posy = abs(vec.dy)
        let larger = max(posx, posy)
        let smaller = min(posx, posy)
        if ( larger > 1) {
            let loopMax = larger - 1
            for n in 1...loopMax {
                let m = Double(n * smaller) / Double(larger)
                if (m.isInteger()) {
                    let xBlocker = (posx > posy ? n : Int(m)) * (vec.dx >= 0 ? 1 : -1)
                    let yBlocker = (posx > posy ? Int(m) : n) * (vec.dy >= 0 ? 1 : -1)
                    blockerList.append(Size(dx:xBlocker, dy:yBlocker))
                }
            }
        }
        return blockerList
    }
    
    // result array is array of vector from pos where ther is an asteroid
    class func makeVisibleAsteroidVectorList(from pos:Position, in asteroidsGrid:BoolGrid) -> [Size] {
        var vectorList:[Size] = []
        for y in 0..<asteroidsGrid.size.dy {
             for x in 0..<asteroidsGrid.size.dx {
                 let nthPos = Position(x:x, y:y)
                 if asteroidsGrid.isMarked(at:nthPos)  && !((pos.x == x) && (pos.y == y)) {

                      // its not itself and there is an asteroid at the other position
                      let vec = Size(dx:x-pos.x , dy:y-pos.y)
                      var isBlocked = false
                      let blockingVactors = getBlockingVectors (for:vec)
                      // now check if any of the blocking vactors are occupied
                      for nthBlocker in blockingVactors {
                          let blockingPos = Position(x:pos.x+nthBlocker.dx, y:pos.y+nthBlocker.dy)
                          if asteroidsGrid.isMarked(at:blockingPos) {
                              isBlocked = true
                          }
                      }
                      if (!isBlocked) {
                          vectorList.append(vec)
                      }
                      
                 }
             }
        }
        return vectorList
    }

    class func countVisibleAsteroids(from pos:Position, in asteroidsGrid:BoolGrid) -> Int {
        var visibleCount = 0
        for y in 0..<asteroidsGrid.size.dy {
             for x in 0..<asteroidsGrid.size.dx {
                 let nthPos = Position(x:x, y:y)
                 if asteroidsGrid.isMarked(at:nthPos)  && !((pos.x == x) && (pos.y == y)) {
                      // its not itself and there is an asteroid at the other position
                      let vec = Size(dx:x-pos.x , dy:y-pos.y)
                      
                      var isBlocked = false
                      let blockingVactors = getBlockingVectors (for:vec)
                      // now check if any of the blocking vactors are occupied
                      for nthBlocker in blockingVactors {
                          let blockingPos = Position(x:pos.x+nthBlocker.dx, y:pos.y+nthBlocker.dy)
                          if asteroidsGrid.isMarked(at:blockingPos) {
                              isBlocked = true
                          }
                      }
                      if (!isBlocked) {
                          visibleCount = visibleCount + 1
                      }
                 }
             }
        }
        return visibleCount
    }
    
    class func makeDetectedAsteroidsGrid(from asteroidsGrid:BoolGrid) -> IntGrid {
    
        let detectedAsteroidsGrid = IntGrid(x:asteroidsGrid.size.dx, y:asteroidsGrid.size.dy)
        
        for y in 0..<asteroidsGrid.size.dy {
            for x in 0..<asteroidsGrid.size.dx {
               let pos = Position(x:x, y:y)
               let hasAsteroid = asteroidsGrid.isMarked(at:pos)
               if hasAsteroid {
                  detectedAsteroidsGrid.setValue(at:pos, to:countVisibleAsteroids(from:pos, in:asteroidsGrid))
               }
            }
         }
         
         return detectedAsteroidsGrid
    }

    func doAoCDay10Part1(with input:String) {
         let lines = input.components(separatedBy:"\n")
         let gridx = lines[0].count
         let gridy = lines.count
         let asteroidsGrid = BoolGrid(x:gridx, y:gridy)
         for y in 0..<gridy {
            let liney = lines[y]
            for x in 0..<gridx {
               if (liney[x] == "#") {
                  asteroidsGrid.mark(position:Position(x:x, y:y))
               }
            }
         }
         asteroidsGrid.spew()
         
         let detectedAsteroidsGrid = AppDelegate.makeDetectedAsteroidsGrid(from:asteroidsGrid)

        detectedAsteroidsGrid.spew()
        
        let maxVal  = detectedAsteroidsGrid.maxVal()
        
        print ("max asteroids visible = \(maxVal) ")
    }

     
     func doAoCDay10Part2(with input:String) {
     
         let testAngle = Size(dx:-4, dy:5).clockwiseAngleFromUp()
         print ("testAngle is \(testAngle)" )

         let lines = input.components(separatedBy:"\n")
         let gridx = lines[0].count
         let gridy = lines.count
         let asteroidsGrid = BoolGrid(x:gridx, y:gridy)
         for y in 0..<gridy {
            let liney = lines[y]
            for x in 0..<gridx {
               if (liney[x] == "#") {
                  asteroidsGrid.mark(position:Position(x:x, y:y))
               }
            }
         }
         asteroidsGrid.spew()
         
         let detectedAsteroidsGrid = AppDelegate.makeDetectedAsteroidsGrid(from:asteroidsGrid)

         detectedAsteroidsGrid.spew()
        
         let (maxVal, maxPos) = detectedAsteroidsGrid.maxValAndPos()
         print ("max asteroids visible = \(maxVal) pos: \(maxPos) ")
         
         var vaporizedCount = 0
         var remainingAsteroids = asteroidsGrid.copy()
         while (remainingAsteroids.countMarks() > 1) {
              // generate list of asteroid vectors
              let vectorList = AppDelegate.makeVisibleAsteroidVectorList(from:maxPos, in:remainingAsteroids)
              let sortedVectorList = vectorList.sorted(by: { $0.clockwiseAngleFromUp() < $1.clockwiseAngleFromUp() } )
              for vec in sortedVectorList {
                   let posOfVaporizedAsteroid = Position(x:maxPos.x+vec.dx ,y: maxPos.y+vec.dy )
                   vaporizedCount = vaporizedCount + 1
                   print ("\(vaporizedCount) asteroid at pos: \(posOfVaporizedAsteroid) vaporized!")
                   asteroidsGrid.unmark(position:posOfVaporizedAsteroid)
              }
              
              remainingAsteroids = asteroidsGrid.copy()
              remainingAsteroids.spew()
         }
     }

     func doAoCPart1() {
         let trimmedInput = getTrimmedInput()
         doAoCDay10Part1(with:trimmedInput)
     }

     func testAoCPart1() {
         let input = getTestInputPart1()
         doAoCDay10Part1(with:input)
     }

    
    func doAoCPart2() {
        let trimmedInput = getTrimmedInput()
        doAoCDay10Part2(with:trimmedInput)
    }

    func testAoCPart2() {
        let input = getTestInputPart2()
        doAoCDay10Part2(with:input)
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        testAoCPart1()
         doAoCPart1()
          //testAoCPart2()
         doAoCPart2()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

