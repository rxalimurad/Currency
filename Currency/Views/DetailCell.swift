//
//  HistoryCell.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    var item: KeyValuePair? {
        didSet {
            setConversionData()
        }
    }
    
    private func setConversionData() {
        guard let item = item else {
            return
        }
        self.label.text = "\(item.key) → \(item.value)"
    }
   

}
