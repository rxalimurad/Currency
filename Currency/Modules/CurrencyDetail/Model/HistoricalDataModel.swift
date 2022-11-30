//
//  HistoricalDataModel.swift
//  Currency
//
//  Created by Ali Murad on 30/11/2022.
//

import Foundation

struct LatestDataModel: Decodable {
    let success: Bool?
    let rates: [String: Double]?
    let error: ErrorObj?
}


struct HistoricalDataModel: Codable {
    let success, timeseries: Bool?
    let startDate, endDate, base: String?
    let rates: [String: [String: Double]]?
    let error: ErrorObj?
    
    enum CodingKeys: String, CodingKey {
        case success, timeseries
        case startDate = "start_date"
        case endDate = "end_date"
        case base, rates, error
    }
}


struct HistoricalRecord {
    var date: String
    var fromCurrency: String
    var toCurrency: String
    var toAmount: String
    var fromAmount: String
}

struct HistoryParam {
    var to: String
    var from: String
    var amount: String
}
