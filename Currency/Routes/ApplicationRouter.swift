//
//  ApplicationRounter.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit
enum Route: String {
    case detailScreen
}


class ApplicationRouter: Router {
    
    
    func route(to routeID: String, from context: UIViewController, parameters: Any?) {
        guard let route = Route(rawValue: routeID) else { return }
        switch route {
        case .detailScreen:
            let vc = UIStoryboard(name: Constants.Storyboard.currency, bundle: nil)
                .instantiateViewController(withIdentifier: Constants.StoryboardId.detailScene) as! CurrencyDetailScene
            vc.param = parameters as? HistoryParam
            context.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
