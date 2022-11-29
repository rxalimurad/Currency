//
//  SelectorModel.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation

struct KeyValuePair: Codable, Comparable {
    static func < (lhs: KeyValuePair, rhs: KeyValuePair) -> Bool {
        return lhs.value < rhs.value
    }
    
    var key = ""
    var value = ""
}
