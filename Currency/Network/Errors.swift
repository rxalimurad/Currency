//
//  Errors.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation
enum NetworkRequestError: Error {
    case unknown
    case requestError
    case notConnected
    case parsingError
    case emptyError
    case serverError(error: String)
}
