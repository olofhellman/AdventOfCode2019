//
//  Intcode.swift
//  Advent of Code 2019
//
//  Created by Olof Hellman on 12/4/19.
//

import Foundation

enum IntcodeInstruction {

    case add(Int, Int, Int)
    case multiply(Int, Int, Int)
    case takeInput(Int)
    case writeOutput(Int)
    case jumpIfTrue(Int, Int)
    case jumpIfFalse(Int, Int)
    case lessThan(Int, Int, Int)
    case equals(Int, Int, Int)
    case changeRelativeBase(Int)
    case halt
    case unknown

     init(_ integer:Int) {
        
        let baseCode = integer%100
        var paramCode = (integer - baseCode) / 100
        var paramCodes:[Int] = []
        for _ in 1...3 {
            let nthParamCode = paramCode%10
            paramCodes.append(nthParamCode)
            paramCode = (paramCode - nthParamCode) / 10
        }
        if ( paramCode != 0) {
            print ("unrecognized param code")
        }
        switch (baseCode) {
            case 1:
               self = .add(paramCodes[0], paramCodes[1], paramCodes[2])
            case 2:
               self = .multiply(paramCodes[0], paramCodes[1], paramCodes[2])
            case 3:
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 3b") }
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 3c") }
               self = .takeInput(paramCodes[0])
            case 4:
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 4b") }
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 4c") }
               self = .writeOutput(paramCodes[0])
            case 5:
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 5c") }
               self = .jumpIfTrue(paramCodes[0], paramCodes[1])
            case 6:
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 6c") }
               self = .jumpIfFalse(paramCodes[0], paramCodes[1])
            case 7:
               self = .lessThan(paramCodes[0], paramCodes[1], paramCodes[2])
            case 8:
               self = .equals(paramCodes[0], paramCodes[1], paramCodes[2])
            case 9:
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 9b") }
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 9c") }
               self = .changeRelativeBase(paramCodes[0])
            case 99:
               if (paramCodes[0] != 0) {  print ("unrecognized param code case 99a") }
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 99b") }
               if (paramCodes[2] != 0) {  print ("unrecognized param code case 99c") }
               self = .halt
            default:
               self = .unknown
               print ("made unknown instruction")
        }
     }
     
     var advanceCount:Int {
        get {
            switch self {
            case .add:
                return 4
            case .multiply:
                return 4
            case .takeInput:
                return 2
            case .writeOutput:
                return 2
            case .halt:
                return 1
            case .unknown:
                return 1
            case .jumpIfTrue:
                return 3
            case .jumpIfFalse:
                return 3
            case .lessThan(_):
                return 4
            case .equals(_):
                return 4
            case .changeRelativeBase:
                return 2
            }
        }
     }
}

class IntcodeEngine {

    public var halted:Bool
    public var currentInstruction:IntcodeInstruction?
    public var currentPosition:Int
    public var integers:[Int]
    public var outOfRangeIntegers:[Int:Int] // key is index, value is value
    public var ioHandler:IOHandler?
    public var nextAdvance:Int
    public var name:String
    public var relativeBase:Int

    init (name:String, input:[Int]) {
        self.name = name
        self.integers = input
        self.currentPosition = 0
        self.halted = false
        self.nextAdvance = 0
        self.relativeBase = 0
        self.outOfRangeIntegers = [:]
    }
    
    public func loadInstruction() {
        let newInstruction = IntcodeInstruction(valueAt(pos:currentPosition))
        currentInstruction = newInstruction
        self.nextAdvance = newInstruction.advanceCount
    }
    
    public func valueAt(pos:Int) -> Int {
        if ((pos >= 0) && (pos < self.integers.count)) {
            return integers[pos]
        }  else {
            return outOfRangeIntegers[pos] ?? 0
        }
    }
    
    public func valueAtIndexAt(pos:Int) -> Int {
        let index = valueAt(pos:pos)
        return valueAt(pos:index)
    }
    
    public func setValueAt(pos:Int, to newValue:Int) {
         if ((pos >= 0) && (pos < self.integers.count)) {
              integers[pos] = newValue
         } else {
             outOfRangeIntegers[pos] = newValue
         }
         
    }
    
    public func takeInput() -> Int {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.global(qos: .background).async {
            var waiting = true
            while (waiting) {
                if let hasInput = self.ioHandler?.hasNextInput() {
                    if (hasInput == true) {
                        waiting = false
                        dispatchGroup.leave()
                    }
                }
            }
        }
        dispatchGroup.wait()
        return ioHandler?.getNextInput() ?? 0
    }
    
    public func writeOutput(_ outputValue:Int) {
        ioHandler?.writeOutput(outputValue)
    }
    
    public func paramValueFor(pos:Int, paramCode:Int) -> Int {
        if ( paramCode == 0 ) {
            return valueAt(pos:valueAt(pos:pos))
        } else if ( paramCode == 1 ) {
            return valueAt(pos:pos)
        } else if ( paramCode == 2 ) {
            return valueAt(pos:valueAt(pos:pos) + self.relativeBase)
        } else {
            print ("unknown param code")
            return 0
        }
    }
    public func writeLocFor(pos:Int, paramCode:Int) -> Int {
        switch paramCode {
            case 0:
                return valueAt(pos:pos)
            case 1:
                print ("write locations cant be in immediate mode")
                return 0
            case 2:
                return valueAt(pos:pos) + relativeBase 
            default:
                print ("unknown param code")
                return 0
        }
    }
    
    public func doInstruction() {
        guard let instruction = currentInstruction else {
            print ("no loaded instruction")
            return
        }
        switch (instruction) {
            case .add(let pc1, let pc2, let pc3):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let writeLoc = writeLocFor(pos:currentPosition + 3, paramCode:pc3)
                let sum = param1 + param2
                setValueAt(pos:writeLoc, to:sum)
            case .multiply(let pc1, let pc2, let pc3):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let writeLoc = writeLocFor(pos:currentPosition + 3, paramCode:pc3)
                let prod = param1 * param2
                setValueAt(pos:writeLoc, to:prod)
            case .takeInput(let pc1):
                let inputValue = takeInput()
                let writeLoc = writeLocFor(pos:currentPosition + 1, paramCode:pc1)
                setValueAt(pos:writeLoc , to:inputValue)
            case .writeOutput(let paramCode):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:paramCode)
                writeOutput(param1)
            case .halt:
                print ("engine \(self.name) halted")
                halted = true
            case .unknown:
                print ("did unknown instruction")
            case .jumpIfTrue(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                if ( param1 != 0 ) {
                    let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                    currentPosition = param2
                    self.nextAdvance = 0
                }
            case .jumpIfFalse(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                if ( param1 == 0 ) {
                    let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                    currentPosition = param2
                    self.nextAdvance = 0
                }
            case .lessThan(let pc1, let pc2, let pc3):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let writeLoc = writeLocFor(pos:currentPosition + 3, paramCode:pc3)
                let valueToWrite = param1 < param2 ? 1 : 0
                setValueAt(pos:writeLoc, to:valueToWrite)
            case .equals(let pc1, let pc2, let pc3):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let writeLoc = writeLocFor(pos:currentPosition + 3, paramCode:pc3)
                let valueToWrite = param1 == param2 ? 1 : 0
                setValueAt(pos:writeLoc, to:valueToWrite)
            case .changeRelativeBase(let pc1):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                self.relativeBase = self.relativeBase + param1
        }
    }

    public func advanceCurrentPosition() {
        self.currentPosition = self.currentPosition + self.nextAdvance
        self.nextAdvance = 0
        currentInstruction = nil;
    }

    public func run() {
        while (!self.halted) {
            advanceCurrentPosition()
            loadInstruction()
            doInstruction()
        }
    }
    
    public func runAsync(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async {
            while (!self.halted) {
                self.advanceCurrentPosition()
                self.loadInstruction()
                self.doInstruction()
            }
            completion()
        }
    }

}


