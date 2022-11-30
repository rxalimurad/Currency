//
//  CurrencyDetailService.swift
//  Currency
//
//  Created by Ali Murad on 30/11/2022.
//

import Foundation
import RxSwift

protocol CurrencyDetailsServiceType {
    init(apiClient: APIClientType)
    func fetchHistory(from: String, to: String, amount: String) -> Observable<Result<[HistoricalRecord], NetworkRequestError>>
    func fetchOtherConversion(from: String, amount: String) -> Observable<Result<[KeyValuePair], NetworkRequestError>>
}

final class CurrencyDetailService: CurrencyDetailsServiceType {
    private let apiClient: APIClientType
    
    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }
    // MARK: - Services
    func fetchHistory(from: String, to: String, amount: String) -> Observable<Result<[HistoricalRecord], NetworkRequestError>> {
        let req = Endpoint(sericeName: .history,
                           method: .get,
                           queryItems: ["base": from,
                                        "symbols": to,
                                        "start_date": Date().getThreeDaysBeforeDate(),
                                        "end_date" : Date().getCurrentDate()
                                       ],
                           header: [Constants.Network.apiKeyParamName: Constants.Network.apiKeyParamValue])
        return apiClient.request(endPoint: req)
            .subscribe(on: MainScheduler.instance)
            .map ({ result  in
                switch result {
                case .Success(let data):
                    let currencyList: HistoricalDataModel?
                    do {
                        currencyList = try JSONDecoder().decode(HistoricalDataModel.self, from: data)
                    } catch _ {
                        return Result<[HistoricalRecord], NetworkRequestError>.Failure(NetworkRequestError.parsingError)
                    }
                    if let historyList = currencyList, historyList.success == true {
                        return Result<[HistoricalRecord], NetworkRequestError>.Success(self.processHistoricalDate(from: from, to: to, rates: historyList.rates, amount: amount))
                    } else {
                        return Result<[HistoricalRecord], NetworkRequestError>.Failure(NetworkRequestError.serverError(error: currencyList?.error?.info ?? "Server Error"))
                    }
                    
                case .Failure(let error):
                    return Result<[HistoricalRecord], NetworkRequestError>.Failure(NetworkRequestError.serverError(error: error.localizedDescription))
                }
            })
    }
    
    
    
    func fetchOtherConversion(from: String, amount: String) -> Observable<Result<[KeyValuePair], NetworkRequestError>> {
        
        
        let req = Endpoint(sericeName: .latest,
                           method: .get,
                           queryItems: ["base": from,
                                        "symbols": "EUR,GBP,JPY,PKR,AED,AUD"],
                           header: [Constants.Network.apiKeyParamName: Constants.Network.apiKeyParamValue])
        return apiClient.request(endPoint: req)
            .subscribe(on: MainScheduler.instance)
            .map ({ result  in
                switch result {
                case .Success(let data):
                    let rateList: LatestDataModel?
                    do {
                        rateList = try JSONDecoder().decode(LatestDataModel.self, from: data)
                    } catch _ {
                        return Result<[KeyValuePair], NetworkRequestError>.Failure(NetworkRequestError.parsingError)
                    }
                    if let rateList = rateList, rateList.success == true {
                        return Result<[KeyValuePair], NetworkRequestError>.Success(self.processLatestData(amount: amount, rateMap: rateList.rates))
                    } else {
                        return Result<[KeyValuePair], NetworkRequestError>.Failure(NetworkRequestError.serverError(error: rateList?.error?.info ?? "Server Error"))
                    }
                    
                case .Failure(let error):
                    return Result<[KeyValuePair], NetworkRequestError>.Failure(NetworkRequestError.serverError(error: error.localizedDescription))
                }
            })
    }
    
    // MARK: - Methods
    private func processLatestData(amount: String, rateMap: [String: Double]?) -> [KeyValuePair] {
        var rateList = [KeyValuePair]()
        if let rateMap = rateMap {
            for (curr, convRate) in rateMap {
                rateList.append(KeyValuePair(key: curr, value: "\(convRate * Double(amount)!)"))
            }
        }
        
        return rateList
    }
    
    private func processHistoricalDate(
        from: String,
        to: String,
        rates: [String: [String: Double]]?,
        amount: String) -> [HistoricalRecord] {
            var list = [HistoricalRecord]()
            if let rates = rates {
                for (date, rate) in rates {
                    let conversionRate = rate[to] ?? 1.0
                    let data = HistoricalRecord(date: date, fromCurrency: from, toCurrency: to, toAmount: "\(conversionRate * Double(amount)!)", fromAmount: amount)
                    list.append(data)
                }
            }
            
            return list
        }
}
