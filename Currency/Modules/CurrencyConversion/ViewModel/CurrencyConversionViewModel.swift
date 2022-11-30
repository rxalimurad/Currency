//
//  CurrencyConversionViewModel.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import Foundation
import RxSwift
import RxCocoa
import PKHUD
protocol ConversionVMDelegate: AnyObject {
    func showError(msg: NetworkRequestError)
}

protocol CurrencyConversionViewModelType {
    var service: CurrencyConversionServiceType { get }
    var delegate: ConversionVMDelegate? { get set}
    init(service: CurrencyConversionServiceType)
    var currencySymbols: PublishSubject<CurrencyModel> { get }
    func fetchCurrencySymbol()
    func covert(from: String, to: String, amount: String, completion: @escaping ((String) -> Void))
    
}
class CurrencyConversionViewModel: CurrencyConversionViewModelType {
    var service: CurrencyConversionServiceType
    var currencySymbols =  PublishSubject<CurrencyModel>()
    weak var delegate: ConversionVMDelegate?
    var disposeBag = DisposeBag()
    required init(service: CurrencyConversionServiceType) {
        self.service = service
    }
    
    
    func fetchCurrencySymbol() {
        DispatchQueue.main.async {
            PKHUD.sharedHUD.contentView = PKHUDProgressView(subtitle: "Fetching currency list")
            PKHUD.sharedHUD.show()
            self.service.getCurrencyList()
                .subscribe(on: MainScheduler.instance)
                .subscribe(onNext: {[weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .Success(let currencyList):
                        self.currencySymbols.onNext(currencyList)
                        self.currencySymbols.onCompleted()
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
    
    func covert(from: String, to: String, amount: String, completion: @escaping ((String) -> Void)) {
        DispatchQueue.main.async {
            PKHUD.sharedHUD.contentView = PKHUDProgressView(subtitle: "Converting currency")
            PKHUD.sharedHUD.show()
            self.service.convertCurrency(from: from, to: to, amount: amount)
                .subscribe(on: MainScheduler.instance)
                .subscribe(onNext: { result in
                    switch result {
                    case .Success(let converted):
                        DispatchQueue.main.async {
                            PKHUD.sharedHUD.hide()
                        }
                      completion("\(converted)")
                    case .Failure(let error):
                        DispatchQueue.main.async {
                            PKHUD.sharedHUD.hide()
                        }
                        self.delegate?.showError(msg: error)
                    }
                }, onError: { error in
                    print(error)
                }, onCompleted: {
                    
                }, onDisposed: {
                    
                })
                .disposed(by: self.disposeBag)

        }
        
            
            
    }
    
}
