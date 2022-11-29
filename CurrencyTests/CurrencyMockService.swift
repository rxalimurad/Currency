//
//  CurrencyConversionMockService.swift
//  CurrencyTests
//
//  Created by murad on 29/10/2022.
//

import Foundation
@testable import Currency

final class CurrencyMockService: CurrencyConversionServiceType {
    func getCurrencyList() -> AnyPublisher<[String: String], NetworkRequestError> {
        Just(MockData.countriesList)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
    }
    
    func getLatestRates() -> AnyPublisher<CurrencyRatesModel, NetworkRequestError> {
        Just(MockData.rateList)
            .setFailureType(to: NetworkRequestError.self)
            .eraseToAnyPublisher()
    }
}

enum MockData {
    static var countriesList: [String: String] = [
        "PKR" : "Pakistani Rupees",
        "USD" : "United States Dollar",
        "JPY" : "Japanese Yen"
    ]
    
    static var rateList: CurrencyRatesModel =  CurrencyRatesModel(disclaimer: "", license: "", timestamp: 1000, base: "USD", rates: [
        "USD" : 1.0,
        "PKR" : 221.375,
        "JPY" : 147.455,
    ]
    )
}
