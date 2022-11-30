//
//  CurrencyDetailViewModel.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD

protocol CurrencyDetailViewModelType {
    var service: CurrencyDetailsServiceType { get }
    var delegate: ConversionVMDelegate? { get set}
    var history: PublishSubject<[HistoricalRecord]>  { get set }
    var otherCurrency: PublishSubject<[KeyValuePair]>  { get set }
    func fetchConversionList(from: String, to: String, amount: String)
    func fetchOtherList(from: String, amount: String)
}


class CurrencyDetailViewModel: CurrencyDetailViewModelType {
    var service: CurrencyDetailsServiceType
    var disposeBag = DisposeBag()
    var delegate: ConversionVMDelegate?
    var history = PublishSubject<[HistoricalRecord]>()
    var otherCurrency = PublishSubject<[KeyValuePair]>()
    
    
    init(service: CurrencyDetailsServiceType) {
        self.service = service
    }
    
    func fetchConversionList(from: String, to: String, amount: String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView(subtitle: "Fetching historical data")
        PKHUD.sharedHUD.show()
        service.fetchHistory(from: from, to: to, amount: amount)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .Success(let historyData):
                    self.history.onNext(historyData)
                    self.history.onCompleted()
                    DispatchQueue.main.async {
                        PKHUD.sharedHUD.hide()
                        self.fetchOtherList(from: from, amount: amount)
                    }
                case .Failure(let error):
                    DispatchQueue.main.async {
                        PKHUD.sharedHUD.hide()
                    }
                    self.delegate?.showError(msg: error)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.hide()
                }
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
            .disposed(by: self.disposeBag)
    }
    
    func fetchOtherList(from: String, amount: String) {
        PKHUD.sharedHUD.contentView = PKHUDProgressView(subtitle: "Fetching famous Currency")
        PKHUD.sharedHUD.show()
        service.fetchOtherConversion(from: from, amount: amount)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] result in
                guard let self = self else { return }
                switch result {
                case .Success(let otherCurrency):
                    self.otherCurrency.onNext(otherCurrency)
                    self.otherCurrency.onCompleted()
                    DispatchQueue.main.async {
                        PKHUD.sharedHUD.hide()
                    }
                case .Failure(let error):
                    DispatchQueue.main.async {
                        PKHUD.sharedHUD.hide()
                    }
                    self.delegate?.showError(msg: error)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    PKHUD.sharedHUD.hide()
                }
            }, onCompleted: {
                
            }, onDisposed: {
                
            })
            .disposed(by: self.disposeBag)
    }
    
}
