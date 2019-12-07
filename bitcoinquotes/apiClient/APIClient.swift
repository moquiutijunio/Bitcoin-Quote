//
//  APIClient.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

protocol APIClientProtocol {
    
}

class APIClient {
    
    static let chartsURLString = "https://api.blockchain.info/charts/transactions-per-second"
}

// MARK: - APIClientProtocol
extension APIClient: APIClientProtocol {
    
    func getBlockchainStatistics() -> Single<[Transaction]> {
        
        return Single.create { (single) -> Disposable in
            guard let url = URL(string: "\(APIClient.chartsURLString)?timespan=1year") else {
                single(.error(APIClient.error(description: NSLocalizedString("generic.error", comment: ""))))
                return Disposables.create()
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, let transactions = Transaction.mapArray(data: data) else {
                    let error = error?.localizedDescription ?? NSLocalizedString("generic.error", comment: "")
                    single(.error(APIClient.error(description: error)))
                    return
                }
                
                single(.success(transactions))
            }.resume()
            
            return Disposables.create()
        }
    }
}

// MARK: - Error
extension APIClient {
    
    static let errorDomain = "APIClient"
    
    static func error(description: String, code: Int = 0) -> NSError {
        
        return NSError(domain: errorDomain,
                       code: code,
                       userInfo: [NSLocalizedDescriptionKey: description])
    }
}
