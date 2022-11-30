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
    
    
}


class CurrencyDetailViewModel {
    var service = CurrencyDetailService(apiClient: APIClient())
    var disposeBag = DisposeBag()
    var delegate: ConversionVMDelegate?
    
    let history = PublishSubject<[HistoricalRecord]>()
    let otherCurrency = PublishSubject<[KeyValuePair]>()
    
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
