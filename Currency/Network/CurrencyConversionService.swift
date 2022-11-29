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
}

final class CurrencyConversionService: CurrencyConversionServiceType {
    private let apiClient: APIClientType
    
    init(apiClient: APIClientType = APIClient()) {
        self.apiClient = apiClient
    }
    
    func getCurrencyList() -> Observable<Result<CurrencyModel, NetworkRequestError>> {
        let req = Endpoint(sericeName: .currencyList,
                           method: .get,
                           header: [Constants.Network.apiKeyParamName: Constants.Network.apiKeyParamValue])
       return apiClient.request(endPoint: req)
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
