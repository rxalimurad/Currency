//
//  HistoryCell.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var date: UILabel!
    var item: HistoricalRecord? {
        didSet {
            setConversionData()
        }
    }
    
    private func setConversionData() {
        guard let item = item else {
            return
        }
        self.date.text = item.date
        self.label.text = "\(item.fromAmount) \(item.fromCurrency) → \(item.toAmount) \(item.toCurrency)"
    }
   

}
