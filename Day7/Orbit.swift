//
//  Orbit.swift
//  AOC2018-1
//
//  Created by Olof Hellman on 12/5/19.
//

import Foundation

struct Orbit {
    let orbiter:String
    let orbitee:String
    init?(_ line:String) {
       let tokens = line.components(separatedBy: ")")
       if ( tokens.count < 2 ) {
           return nil
       }
       self.orbitee = tokens[0]
       self.orbiter = tokens[1]
    }
}

class Orbiter {
   let name:String
   let orbitee:Orbiter?
   var satellites:[Orbiter]

    init(name:String, orbitee:Orbiter?) {
        self.name = name
        self.orbitee = orbitee
        self.satellites = []
    }
    func add(satellite:Orbiter) {
        satellites.append(satellite)
    }
    
    func countSatellites() -> Int {
       return satellites.reduce(0, {$0 + 1 + $1.countSatellites()} )
    }
    
    func countOrbits() -> Int {
       return countSatellites() + satellites.reduce(0, {$0 + $1.countOrbits()} )
    }

     func listOfSuperOrbiterNames() -> [String] {
          guard let parent = orbitee else {
              return []
          }
          return [parent.name] + parent.listOfSuperOrbiterNames()
     }

     func has(suborbiter:Orbiter) -> Bool {
          let listOfSuperOrbiters = suborbiter.listOfSuperOrbiterNames()
          return listOfSuperOrbiters.contains(self.name)
     }
     
     func countJumpsTo(superorbiter:Orbiter) -> Int {
         guard let myOrbitee = orbitee else {
             print (" no orbitee")
             return -1
         }
         if (superorbiter.name == myOrbitee.name) {
             return 1
         } else {
             return 1 + myOrbitee.countJumpsTo(superorbiter:superorbiter)
         }
     }

}

class OrbiterTree {
    var root:Orbiter
    var orbiterDict:[String:Orbiter]

    init(orbits:[Orbit]) {
        let rootOrbiter  = Orbiter(name:"COM", orbitee:nil)
        self.orbiterDict = ["COM":rootOrbiter]
        self.root = rootOrbiter
        var unplacedOrbits = orbits
        while (unplacedOrbits.count > 0) {
           var notYet:[Orbit] = []
           for orbit in unplacedOrbits {
              if let newOrbiter =  self.add(orbit:orbit)  {
                 self.orbiterDict[newOrbiter.name] = newOrbiter
              } else {
                  notYet.append(orbit)
              }
           }
           unplacedOrbits = notYet
           print("\(notYet.count) orbits not yet inserted")
        }
    }
    
    func add(orbit:Orbit) -> Orbiter? {
        guard let orbitee = orbiterDict[orbit.orbitee] else {
            return nil
        }
        let newOrbiter = Orbiter(name:orbit.orbiter, orbitee:orbitee)
        orbitee.add(satellite:newOrbiter)
        return newOrbiter
    }
    
    func countOrbits() -> Int {
       return root.countOrbits()
    }
    
    func countJumps(from start:String, to dest:String) -> Int {
        var jumps = 0
        guard let startOrbiter = orbiterDict[start] else
        {
            print ("cant find start")
            return -1
        }
        guard let destOrbiter = orbiterDict[dest] else
        {
            print ("cant find dest")
            return -1
        }
        guard var candidateOrbiter = startOrbiter.orbitee else {
             print ("no orbitee")
             return -1
        }
 
        while (!candidateOrbiter.has(suborbiter:destOrbiter)) {
            jumps = jumps + 1
            guard let nextOrbiterUp = candidateOrbiter.orbitee  else {
               print ("no orbitee case B")
               return -1
            }
            candidateOrbiter = nextOrbiterUp
        }
        return jumps + destOrbiter.countJumpsTo(superorbiter:candidateOrbiter) - 1
    }
 }
