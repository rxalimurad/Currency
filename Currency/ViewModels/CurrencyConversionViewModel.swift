//
//  CurrencyConversionViewModel.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import Foundation
import RxSwift

protocol CurrencyConversionViewModelType {
    var service: CurrencyConversionServiceType { get }
    init(service: CurrencyConversionServiceType)
    var currencySymbols: PublishSubject<CurrencyModel> { get }
    func fetchCurrencySymbol()
    
}
class CurrencyConversionViewModel: CurrencyConversionViewModelType {
    var service: CurrencyConversionServiceType
    var currencySymbols =  PublishSubject<CurrencyModel>()
    
    required init(service: CurrencyConversionServiceType) {
        self.service = service
        fetchCurrencySymbol()
    }
    
    
    func fetchCurrencySymbol() {
        service.getCurrencyList()
            .map {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .Success(let currencyList):
                    self.currencySymbols.onNext(currencyList)
                    self.currencySymbols.onCompleted()
                case .Failure(let error):
                    print(error)
                }
            }
        
            
            
    }
    
    
}
