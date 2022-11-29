//
//  APIClient.swift
//  Currency
//
//  Created by murad on 28/10/2022.
//

import Foundation
import RxSwift

enum Result<T, Error> {
    case Success(T)
    case Failure(Error)
}

protocol APIClientType {
    func request(endPoint: URLRequestConvertibleType) -> Observable<Result<Data, NetworkRequestError>>
}


final class APIClient: APIClientType {
    
    func request(endPoint: URLRequestConvertibleType) -> Observable<Result<Data, NetworkRequestError>> {
        let urlRequest = (try? endPoint.urlRequest())!
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        return Observable.create { observer in
            var result: Result<Data, NetworkRequestError>?
            dataTask = defaultSession.dataTask(with: urlRequest) { data, response, error in
                if let data = data, let response = response as? HTTPURLResponse,  response.statusCode == 200 {
                    result = Result<Data, NetworkRequestError>.Success(data)
                } else {
                    if let error = error {
                        result = Result<Data, NetworkRequestError>.Failure(NetworkRequestError.serverError(error: error.localizedDescription))
                    }
                }
                observer.onNext(result!)
                observer.onCompleted()
            }
            dataTask?.resume()
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}

