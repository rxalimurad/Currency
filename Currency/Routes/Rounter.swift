//
//  Rounter.swift
//  Currency
//
//  Created by murad on 29/11/2022.
//

import UIKit

protocol Router {
   func route(
      to routeID: String,
      from context: UIViewController,
      parameters: Any?
   )
}
