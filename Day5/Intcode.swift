//
//  Intcode.swift
//  Advent of Code 2019
//
//  Created by Olof Hellman on 12/4/19.
//

import Foundation

enum IntcodeInstruction {

    case add(Int, Int)
    case multiply(Int, Int)
    case takeInput
    case writeOutput(Int)
    case jumpIfTrue(Int, Int)
    case jumpIfFalse(Int, Int)
    case lessThan(Int, Int)
    case equals(Int, Int)
    case halt
    case unknown

     init(_ integer:Int) {
        let baseCode = integer%100
        var paramCode = (integer - baseCode) / 100
        var paramCodes:[Int] = []
        for _ in 1...2 {
            let nthParamCode = paramCode%10
            paramCodes.append(nthParamCode)
            paramCode = (paramCode - nthParamCode) / 10
        }
        if ( paramCode != 0) {
            print ("unrecognized param code")
        }
        switch (baseCode) {
            case 1:
               self = .add(paramCodes[0], paramCodes[1])
            case 2:
               self = .multiply(paramCodes[0], paramCodes[1])
            case 3:
               if (paramCodes[0] != 0) {  print ("unrecognized param code case 99a") }
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 3") }
               self = .takeInput
            case 4:
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 4") }
               self = .writeOutput(paramCodes[0])
            case 5:
               self = .jumpIfTrue(paramCodes[0], paramCodes[1])
            case 6:
               self = .jumpIfFalse(paramCodes[0], paramCodes[1])
            case 7:
               self = .lessThan(paramCodes[0], paramCodes[1])
            case 8:
               self = .equals(paramCodes[0], paramCodes[1])
            case 99:
               if (paramCodes[0] != 0) {  print ("unrecognized param code case 99a") }
               if (paramCodes[1] != 0) {  print ("unrecognized param code case 99b") }
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
            }
        }
     }
}

class IntcodeEngine {

    public var halted:Bool
    public var currentInstruction:IntcodeInstruction?
    public var currentPosition:Int
    public var integers:[Int]
    public var ioHandler:IOHandler?
    public var nextAdvance:Int

    init (input:[Int]) {
        self.integers = input
        self.currentPosition = 0
        self.halted = false
        self.nextAdvance = 0
    }
    
    public func loadInstruction() {
        let newInstruction = IntcodeInstruction(valueAt(pos:currentPosition))
        currentInstruction = newInstruction
        self.nextAdvance = newInstruction.advanceCount
    }
    
    public func valueAt(pos:Int) -> Int {
        guard pos < self.integers.count else {
             print ("out of range")
             return 0
        }
        return integers[pos]
    }
    
    public func valueAtIndexAt(pos:Int) -> Int {
        let index = valueAt(pos:pos)
        if index >= self.integers.count {
             let indicesToAdd = (1 + index) - self.integers.count
 
             print ("index out of range -- adding \(indicesToAdd) integers to array")
             while (index >= self.integers.count) {
                 self.integers.append(0)
             }
        }
        return valueAt(pos:index)
    }
    
    public func setValueAt(pos:Int, to newValue:Int) {
         guard pos < self.integers.count else {
              print ("pos out of range")
              return
         }
         integers[pos] = newValue
    }
    
    public func takeInput() -> Int {
        return ioHandler?.getNextInput() ?? 0
    }
    
    public func writeOutput(_ outputValue:Int) {
        ioHandler?.writeOutput(outputValue)
    }
    
    public func paramValueFor(pos:Int, paramCode:Int) -> Int {
        if ( paramCode == 0 ) {
            return valueAtIndexAt(pos:pos)
        } else if ( paramCode == 1 ) {
            return valueAt(pos:pos)
        } else {
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
            case .add(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let sum = param1 + param2
                setValueAt(pos:valueAt(pos:currentPosition + 3), to:sum)
            case .multiply(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let prod = param1 * param2
                setValueAt(pos:valueAt(pos:currentPosition + 3), to:prod)
            case .takeInput:
                let inputValue = takeInput()
                setValueAt(pos:valueAt(pos:currentPosition + 1), to:inputValue)
            case .writeOutput(let paramCode):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:paramCode)
                writeOutput(param1)
            case .halt:
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
            case .lessThan(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let valueToWrite = param1 < param2 ? 1 : 0
                setValueAt(pos:valueAt(pos:currentPosition + 3), to:valueToWrite)
            case .equals(let pc1, let pc2):
                let param1 = paramValueFor(pos:currentPosition + 1, paramCode:pc1)
                let param2 = paramValueFor(pos:currentPosition + 2, paramCode:pc2)
                let valueToWrite = param1 == param2 ? 1 : 0
                setValueAt(pos:valueAt(pos:currentPosition + 3), to:valueToWrite)
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
}


