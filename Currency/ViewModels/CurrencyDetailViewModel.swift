//
//  CurrencyDetailViewModel.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyDetailViewModel {
    
    let history = PublishSubject<[KeyValuePair]>()
    let otherCurrency = PublishSubject<[KeyValuePair]>()
    
    func fetchConversionList() {
            let productArray = [
                KeyValuePair(key: "2 USD", value: "10 JPY"),
                KeyValuePair(key: "9 USD", value: "8 AUD"),
                KeyValuePair(key: "1.0 CAD", value: "0.99 AED")
            ]
        
        history.onNext(productArray)
        history.onCompleted()
    }
    
    func fetchOtherList() {
            let productArray = [
                KeyValuePair(key: "32 USD", value: "1.32 JPY"),
                KeyValuePair(key: "0.34 USD", value: "0.38 AUD"),
                KeyValuePair(key: "1.2 CAD", value: "0.09 AED")
            ]
        
        otherCurrency.onNext(productArray)
        otherCurrency.onCompleted()
    }
    
}
