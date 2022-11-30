//
//  CurrencyConversionService.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation
import RxSwift
protocol CurrencyConversionServiceType {
    func getCurrencyList() -> Observable<Result<CurrencyModel, NetworkRequestError>>
    func convertCurrency(from: String, to: String, amount: String) -> Observable<Result<Double, NetworkRequestError>>
}

final class CurrencyConversionService: CurrencyConversionServiceType {
    private let apiClient: APIClientType
    
    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }
    
    func convertCurrency(from: String, to: String, amount: String) -> Observable<Result<Double, NetworkRequestError>> {
        let req = Endpoint(sericeName: .convert,
                           method: .get,
                           queryItems: ["from": from, "to": to, "amount": amount],
                           header: [Constants.Network.apiKeyParamName: Constants.Network.apiKeyParamValue])
        return apiClient.request(endPoint: req)
             .subscribe(on: MainScheduler.instance)
             .map ({ result  in
                 switch result {
                 case .Success(let data):
                     let currencyList: CurrencyModel?
                     do {
                         currencyList = try JSONDecoder().decode(CurrencyModel.self, from: data)
                     } catch _ {
                         return Result<Double, NetworkRequestError>.Failure(NetworkRequestError.parsingError)
                     }
                     if let currencyList = currencyList, currencyList.success == true {
                         return Result<Double, NetworkRequestError>.Success(currencyList.result ?? 0.0)
                     } else {
                         return Result<Double, NetworkRequestError>.Failure(NetworkRequestError.serverError(error: currencyList?.error?.info ?? "Server Error"))
                     }
                     
                 case .Failure(let error):
                     return Result<Double, NetworkRequestError>.Failure(NetworkRequestError.serverError(error: error.localizedDescription))
                 }
             })
    }
    
    func getCurrencyList() -> Observable<Result<CurrencyModel, NetworkRequestError>> {
        let req = Endpoint(sericeName: .currencyList,
                           method: .get,
                           header: [Constants.Network.apiKeyParamName: Constants.Network.apiKeyParamValue])
       return apiClient.request(endPoint: req)
            .subscribe(on: MainScheduler.instance)
            .map ({ result  in
                switch result {
                case .Success(let data):
                    let currencyList: CurrencyModel?
                    do {
                        currencyList = try JSONDecoder().decode(CurrencyModel.self, from: data)
                    } catch _ {
                        return Result<CurrencyModel, NetworkRequestError>.Failure(NetworkRequestError.parsingError)
                    }
                    if let currencyList = currencyList, currencyList.success == true {
                        return Result<CurrencyModel, NetworkRequestError>.Success(currencyList)
                    } else {
                        return Result<CurrencyModel, NetworkRequestError>.Failure(NetworkRequestError.serverError(error: currencyList?.error?.info ?? "Server Error"))
                    }
                    
                case .Failure(let error):
                    return Result<CurrencyModel, NetworkRequestError>.Failure(NetworkRequestError.serverError(error: error.localizedDescription))
                }
            })
            
        
        
    }
    
}
