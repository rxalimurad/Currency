//
//  Array.swift
//  Currency
//
//  Created by murad on 29/10/2022.
//

import Foundation
extension Collection where Element: Comparable {
    var isSorted: Bool {
        guard count > 1 else {
            return true
        }

        let pairs = zip(prefix(count - 1), suffix(count - 1))

        return !pairs.contains { previous, next in
            previous > next
        }
    }
}
