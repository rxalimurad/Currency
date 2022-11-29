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
    var param: (String?, String?)? = nil
    //MARK: - Outlets
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var otherCurrencyTable: UITableView!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTable.rx.setDelegate(self).disposed(by: bag)
        otherCurrencyTable.rx.setDelegate(self).disposed(by: bag)
        bindTableViews()
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
            cell.item = item
        }.disposed(by: bag)
        
        // fetch data
        viewModel.fetchConversionList()
        viewModel.fetchOtherList()
    }
}

