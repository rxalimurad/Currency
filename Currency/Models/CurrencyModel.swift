//
//  CurrencyModel.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import Foundation

struct CurrencyModel: Decodable {
    let success: Bool?
    let symbols: [String: String]?
    let error: ErrorObj?
    let info: Info?
    let result: Double?
    
}

struct Info: Decodable {
    let rate: Double?
}
struct ErrorObj: Decodable {
    let code: Int?
    let type: String?
    let info: String?
}
