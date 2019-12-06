//
//  IOHandler.swift
//  Advent of Code 2019
//
//  Created by Olof Hellman on 12/4/19.
//

import Foundation

protocol IOHandler {
    func getNextInput() -> Int
    func writeOutput(_ outputValue:Int)
}

class TESTDiagnosticDay5Part1IOHandler : IOHandler {
    func getNextInput() -> Int {
        return 1
    }
    func writeOutput(_ outputValue:Int) {
        print ( "TESTDiagnosticIOHandler output: \(outputValue)")
    }
}

class TESTDiagnosticDay5Part2IOHandler : IOHandler {
    func getNextInput() -> Int {
        return 5
    }
    func writeOutput(_ outputValue:Int) {
        print ( "TESTDiagnosticIOHandler output: \(outputValue)")
    }
}
