//
//  Double+IntegerTest.swift
//  AOC2019D10
//
//  Created by Olof Hellman on 12/10/19.
//  Copyright © 2019 Microsoft. All rights reserved.
//

import Foundation

extension Double {
    func isInteger() -> Bool {
        return Double(Int(self)) == self
    }
}
