//
//  StringSubscripts.swift
//  AOC2018-1
//
//  Created by olof on 12/4/18.
//  Copyright © 2018 Microsoft. All rights reserved.
//

import Foundation

extension StringProtocol {

    var string: String { return String(self) }

    subscript(offset: Int) -> Element {
        return self[index(startIndex, offsetBy: offset)]
    }

    subscript(_ range: CountableRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }
    subscript(range: CountableClosedRange<Int>) -> SubSequence {
        return prefix(range.lowerBound + range.count)
            .suffix(range.count)
    }

    subscript(range: PartialRangeThrough<Int>) -> SubSequence {
        return prefix(range.upperBound.advanced(by: 1))
    }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence {
        return prefix(range.upperBound)
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence {
        return suffix(Swift.max(0, count - range.lowerBound))
    }
}
extension Substring {
    var string: String { return String(self) }
}
