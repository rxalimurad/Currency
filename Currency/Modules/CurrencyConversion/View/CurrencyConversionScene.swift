//
//  ViewController.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyConversionScene: UIViewController {
    // MARK: - Outlets
    @IBOutlet private var fromCurrSelector: SelectorInputWidget!
    @IBOutlet private var toCurrSelector: SelectorInputWidget!
    @IBOutlet private var fromAmountInput: TextInputWidget!
    @IBOutlet private var toAmountInput: TextInputWidget!
    @IBOutlet private var detailBtn: UIButton!
    
    
    // MARK: - Properties
    let rounter: Router = ApplicationRouter()
    private var viewModel: CurrencyConversionViewModelType = CurrencyConversionViewModel(service: CurrencyConversionService())
    private var bag = DisposeBag()
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addObserverOnSymbols()
        DispatchQueue.main.async {
            self.viewModel.fetchCurrencySymbol()
        }
       setDelegates()
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionForDetailBtn(sender: UIButton) {
        rounter.route(to: Route.detailScreen.rawValue, from: self,
                      parameters: HistoryParam(to: toCurrSelector.currentSelectedValue?.key ?? "",
                                               from: fromCurrSelector.currentSelectedValue?.key ?? "",
                                               amount: fromAmountInput.text ?? ""))
    }
    @IBAction func actionForSwapBtn(sender: UIButton) {
        let old = fromCurrSelector.currentSelectedValue
        fromCurrSelector.currentSelectedValue = toCurrSelector.currentSelectedValue
        toCurrSelector.currentSelectedValue = old
        let oldText = fromCurrSelector.text!
        fromCurrSelector.text = toCurrSelector.text
        toCurrSelector.text = oldText
        self.convertAmounts()
    }
    
    
    // MARK: - Methods
    private func setDelegates() {
        fromCurrSelector.delegate = self
        toCurrSelector.delegate = self
        fromAmountInput.delegate = self
        toAmountInput.delegate = self
        viewModel.delegate = self
        toAmountInput.isUserInteractionEnabled = false
        detailBtn.isHidden = true
    }
    
    private func addObserverOnSymbols() {
        viewModel.currencySymbols
            .subscribe {[weak self] currencyModel in
                guard let self = self else { return }
                self.fromCurrSelector.setData(data: currencyModel.symbols ?? [:])
                self.toCurrSelector.setData(data: currencyModel.symbols ?? [:])
            } onError: { _ in } onCompleted: { } onDisposed: {}
            .disposed(by: bag)
    }
}
// MARK: - View Model Delegate
extension CurrencyConversionScene: ConversionVMDelegate {
    func showError(msg: NetworkRequestError) {
        switch msg {
        case .serverError(let error):
            self.showToast(message: error, font: .systemFont(ofSize: 20))
        default:
            self.showToast(message: "\(msg)", font: .systemFont(ofSize: 20))
        }
        
    }
}

// MARK: - UITextfield Delegate implementation
extension CurrencyConversionScene: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textView: UITextField) {
        if !fromCurrSelector.text!.isEmpty
            && !toCurrSelector.text!.isEmpty
            && !fromAmountInput.text!.isEmpty {
            detailBtn.isHidden = false
                convertAmounts()
        } else {
            detailBtn.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == NumberFormatter().decimalSeparator &&
            textField.text!.contains(NumberFormatter().decimalSeparator)
        {
            return false
        }
        return true
    }
    private func convertAmounts() {
        viewModel.covert(
            from: fromCurrSelector.currentSelectedValue?.key ?? "",
            to: toCurrSelector.currentSelectedValue?.key ?? "",
            amount: fromAmountInput.text!) { convertedAmount in
                DispatchQueue.main.async {
                    self.toAmountInput.text = convertedAmount
                }
            }
    }
}
