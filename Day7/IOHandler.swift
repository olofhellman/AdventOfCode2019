import Foundation

protocol IOHandler {
    func hasNextInput() -> Bool
    func getNextInput() -> Int
    func writeOutput(_ outputValue:Int)
}

class TESTDiagnosticDay5Part1IOHandler : IOHandler {
    func hasNextInput() -> Bool {
       return true
    }
    func getNextInput() -> Int {
        return 1
    }
    func writeOutput(_ outputValue:Int) {
        print ( "TESTDiagnosticIOHandler output: \(outputValue)")
    }
}

class TESTDiagnosticDay5Part2IOHandler : IOHandler {
    func hasNextInput() -> Bool {
       return true
    }
    func getNextInput() -> Int {
        return 5
    }
    func writeOutput(_ outputValue:Int) {
        print ( "TESTDiagnosticIOHandler output: \(outputValue)")
    }
}

class AmplifierIOHandler : IOHandler {
 
    var phaseSettings:[Int]
    var currentSignal:Int?
    var usePhaseSetting:Bool
    var phaseSettingIndex:Int
    
    init(phaseSettings:[Int]) {
        self.phaseSettings = phaseSettings
        self.phaseSettingIndex = 0
        self.usePhaseSetting = true
        self.currentSignal = 0;
    }
    
    func hasNextInput() -> Bool {
       return true
    }

    func getNextInput() -> Int {
        var nextInput:Int = 0
        if (usePhaseSetting) {
            nextInput = self.phaseSettings[self.phaseSettingIndex]
            print ( "AmplifierIOHandler using phaseSetting: \(nextInput)")
            self.phaseSettingIndex = self.phaseSettingIndex + 1
        } else {
            guard let currentSig = self.currentSignal else {
                print ("unexpected input")
                return 0
            }
            nextInput = currentSig
            print ( "AmplifierIOHandler using signal: \(nextInput)")
            self.currentSignal = nil
        }
        usePhaseSetting = !usePhaseSetting
        return nextInput
    }
    
    func writeOutput(_ outputValue:Int) {
        print ( "AmplifierIOHandler output: \(outputValue)")
        currentSignal = outputValue
    }
}

 
class AmplifierPart2IOHandler : IOHandler {
 
    var phaseSetting:Int
    var currentSignal:Int?
    var usePhaseSetting:Bool
    var outputAmp:AmplifierPart2IOHandler?

    func hasNextInput() -> Bool {
       return self.usePhaseSetting  || (currentSignal != nil)
    }

    init(phaseSetting:Int) {
        self.phaseSetting = phaseSetting
        self.usePhaseSetting = true
        self.currentSignal = nil;
        self.outputAmp = nil
    }
        
    func receiveSignal(signal:Int) {
        if ( currentSignal != nil) {
            print ("needs buffer")
        }
        self.currentSignal = signal
    }
        
    func getNextInput() -> Int {
        var nextInput:Int = 0
        if (usePhaseSetting) {
            nextInput = self.phaseSetting
            print ( "AmplifierIOHandler using phaseSetting: \(nextInput)")
            usePhaseSetting = false;
        } else {
            guard let currentSig = self.currentSignal else {
                print ("unexpected input")
                return 0
            }
            nextInput = currentSig
            print ( "AmplifierIOHandler using signal: \(nextInput)")
            self.currentSignal = nil
        }
        
        return nextInput
    }
    
    func writeOutput(_ outputValue:Int) {
        print ( "AmplifierIOHandler output: \(outputValue)")
        if ( currentSignal != nil) {
            print ("needs buffer")
        }
        currentSignal = outputValue
        outputAmp?.receiveSignal(signal:outputValue)
        currentSignal = nil
    }
}
