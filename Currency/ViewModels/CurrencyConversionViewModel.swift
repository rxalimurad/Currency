//
//  CurrencyConversionViewModel.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation
import Combine
protocol CurrencyConversionVMType: ObservableObject {
    var currencyListModel: CountriesListModel {get set}
    var rateList: CurrencyRatesModel? {get set}
    var showError: Bool  {get set}
    func convertAmount(amount: Double, from: String, to: String) -> Double?
    
}

final class CurrencyConversionViewModel: CurrencyConversionVMType {
    // MARK: - Properties
    private var service: CurrencyConversionServiceType
    private var subscriptions: [AnyCancellable] = []
    @Published var currencyListModel = CountriesListModel(currencyList: [])
    @Published var rateList:  CurrencyRatesModel?
    @Published var showError: Bool = false
    
    // MARK: - Initalizer
    init(service: CurrencyConversionServiceType) {
        self.service = service
        fetchCurrencyList()
        fetchRateList()
    }
    
    // MARK: - Methods
    func convertAmount(amount: Double, from: String, to: String) -> Double? {
        if let conversionFector = getCoversionRate(from: from, to: to) {
            return amount * conversionFector
        }
        return nil
    }
    
    private func getCoversionRate(from: String, to: String) -> Double? {
        if let fromInOneUSD = self.rateList?.rates[from],
           let toInOneUSD = self.rateList?.rates[to] {
            return  toInOneUSD / fromInOneUSD
        }
        return to == from ? 1.0 : nil
    }
    
    private func isNeededToFetchCurrencyList() -> Bool {
        if let savedDate = Preference.backUpDate {
            if (Date().timeIntervalSince1970 - savedDate) < Constants.Global.cacheTimeInMinutes * 60 {
                return Preference.countryList == nil
            }
        }
        return true
    }
    private func isNeededToFetchRateList() -> Bool {
        if let savedDate = Preference.backUpDate {
            if (Date().timeIntervalSince1970 - savedDate) < Constants.Global.cacheTimeInMinutes * 60 {
                return Preference.rateList == nil
            }
        }
        return true
    }
    
    
    // MARK: - Serivce calls
    private func fetchCurrencyList() {
        // if data is already cached and it's been cached for less than cacheTimeInMinutes minuts
        // no need to send api call
        if isNeededToFetchCurrencyList() {
            debugPrint("fetching currency list from Server \(service.self)")
            self.service.getCurrencyList()
                .receive(on: RunLoop.main)
                .sink {[weak self] error in
                    if case Subscribers.Completion.failure(_) = error {
                        self?.showError = true
                        debugPrint(error)
                    }

                } receiveValue: {[weak self]  list in
                    guard let self = self else { return }
                    var keyValueList = [KeyValuePair]()
                    list.forEach { element in
                        keyValueList.append(KeyValuePair(key: element.key, value: element.value))
                    }
                    keyValueList.sort(by: { $0.value < $1.value })
                    self.currencyListModel = CountriesListModel(currencyList: keyValueList)
                    //Saving data in user defaults
                    Preference.countryList = self.currencyListModel
                    Preference.backUpDate = Date().timeIntervalSince1970
                }.store(in: &subscriptions)
        } else {
            debugPrint("fetching currency list from cache")
            self.currencyListModel = Preference.countryList!
        }
    }
    
    private func fetchRateList() {
        // if data is already cached and it's been cached for less than cacheTimeInMinutes minuts
        // no need to send api call
        if isNeededToFetchRateList() {
            debugPrint("fetching rate list from Server \(service.self)")
            self.service.getLatestRates()
                .receive(on: RunLoop.main)
                .sink {[weak self] error in
                    if case Subscribers.Completion.failure(_) = error {
                        self?.showError = true
                        debugPrint(error)
                    }
                } receiveValue: {[weak self] currencyRates in
                    guard let self = self else { return }
                    self.rateList = currencyRates
                    //Saving data in user defaults
                    Preference.rateList = self.rateList
                    Preference.backUpDate = Date().timeIntervalSince1970
                }
                .store(in: &subscriptions)
        } else {
            debugPrint("fetching rate list from cache")
            self.rateList = Preference.rateList!
        }
        
        
    }
    
    
    
    
    
}
