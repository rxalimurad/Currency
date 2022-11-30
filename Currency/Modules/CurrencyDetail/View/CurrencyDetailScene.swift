//
//  CurrencyDetailScene.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit
import RxSwift
import RxCocoa

class CurrencyDetailScene: UIViewController, UITableViewDelegate {
    //MARK: - Properties
    private let bag = DisposeBag()
    private let viewModel = CurrencyDetailViewModel()
    var param: HistoryParam? = nil
    //MARK: - Outlets
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var otherCurrencyTable: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.rx.setDelegate(self).disposed(by: bag)
        otherCurrencyTable.rx.setDelegate(self).disposed(by: bag)
        bindTableViews()
        viewModel.delegate = self
    }
    
    //MARK: - Methods
    private func bindTableViews() {
        // register cells
        historyTable.register(UINib(nibName: Constants.cell.detailCell, bundle: nil), forCellReuseIdentifier: Constants.cell.detailCell)
        otherCurrencyTable.register(UINib(nibName: Constants.cell.detailCell, bundle: nil), forCellReuseIdentifier: Constants.cell.detailCell)
        
        // bind cells with viewmodel
        viewModel.history.bind(to: historyTable.rx.items(cellIdentifier: Constants.cell.detailCell, cellType: DetailCell.self)) { (row,item,cell) in
            cell.item = item
        }.disposed(by: bag)
        
        viewModel.otherCurrency.bind(to: otherCurrencyTable.rx.items(cellIdentifier: Constants.cell.detailCell, cellType: DetailCell.self)) { (row,item,cell) in
            let data = HistoricalRecord(date: item.key, fromCurrency: self.param!.from, toCurrency: item.key, toAmount: item.value, fromAmount: self.param!.amount)
            cell.item = data
        }.disposed(by: bag)
        
        // fetch data
        if let param = param {
            viewModel.fetchConversionList(from: param.from, to: param.to, amount: param.amount)
        }
        
    }
}

extension CurrencyDetailScene: ConversionVMDelegate {
    func showError(msg: NetworkRequestError) {
        switch msg {
        case .serverError(let error):
            self.showToast(message: error, font: .systemFont(ofSize: 20))
        default:
            self.showToast(message: "\(msg)", font: .systemFont(ofSize: 20))
        }
    }
    
    
}

