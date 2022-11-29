//
//  URLRequestConvertibleType.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation

protocol URLRequestConvertibleType {
    func urlRequest() throws -> URLRequest
}
enum HTTPMethod {
    case get
    case post(body: Data?)
    
    var toString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
enum ServiceNames: String {
    case currencyList = "/fixer/symbols"
    case convert = "/fixer/convert"
}

struct Endpoint {
    private let scheme: String = "https"
    private let host: String = "api.apilayer.com"
    private let sericeName: ServiceNames
    private let method: HTTPMethod
    private let queryItems: [String: Any]?
    private let path: [String]?
    private let header: [String: String]?
    
    fileprivate var url: URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = sericeName.rawValue + (path?.compactMap { "/\($0)" }.joined() ?? "")
        components.queryItems = queryItems?.compactMap { URLQueryItem(name: $0.key, value: $0.value as? String) }
        return components.url
    }
    
    init(sericeName: ServiceNames,
         method: HTTPMethod,
         path: [String]? = nil,
         queryItems: [String: String]? = nil,
         header: [String: String]? = nil) {
        self.sericeName = sericeName
        self.method = method
        self.path = path
        self.queryItems = queryItems
        self.header = header
    }
    
}

extension Endpoint: URLRequestConvertibleType {
    func urlRequest() throws -> URLRequest {
        guard let url = url else { throw NetworkRequestError.serverError(error: "Invalid URL") }
        var request = URLRequest(url: url)
        request.httpMethod = method.toString
        if case let HTTPMethod.post(body) = method {
            request.httpBody = body
        }
        header?.forEach({ (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        })
        return request
    }
}
