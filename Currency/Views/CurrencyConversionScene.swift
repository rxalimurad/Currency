//
//  ViewController.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import UIKit

class CurrencyConversionScene: UIViewController {
    // MARK: - Outlets
    
    
    
    // MARK: - Properties
    let rounter: Router = ApplicationRouter()
    private let viewModel = CurrencyConversionViewModel(service: CurrencyConversionService())
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }
    
    // MARK: - Actions
    
    @IBAction func actionForDetailBtn(sender: UIButton) {
        rounter.route(to: Route.detailScreen.rawValue, from: self, parameters: nil)
    }
    
    // MARK: - Methods
}
