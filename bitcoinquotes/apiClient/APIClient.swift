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
    var blockchainStatisticsRequestResponse: Observable<RequestResponse<[Transaction]>> { get }
        
    func getBlockchainStatistics(timespan: String)
}

class APIClient {
    
    static let chartsURLString = "https://api.blockchain.info/charts/transactions-per-second"
    
    private var blockchainStatisticsRequestResponseSubject = BehaviorSubject<RequestResponse<[Transaction]>>(value: .new)
}

// MARK: - APIClientProtocol
extension APIClient: APIClientProtocol {
    
    var blockchainStatisticsRequestResponse: Observable<RequestResponse<[Transaction]>> {
        return blockchainStatisticsRequestResponseSubject
            .asObservable()
    }
    
    func getBlockchainStatistics(timespan: String) {
        blockchainStatisticsRequestResponseSubject.onNext(.loading)
        
        guard let url = URL(string: "\(APIClient.chartsURLString)?timespan=\(timespan)") else {
            blockchainStatisticsRequestResponseSubject.onNext(.failure(NSLocalizedString("generic.error", comment: "")))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [unowned self] (data, response, error) in
            guard let data = data, let transactions = Transaction.mapArray(data: data) else {
                let error = error?.localizedDescription ?? NSLocalizedString("generic.error", comment: "")
                self.blockchainStatisticsRequestResponseSubject.onNext(.failure(error))
                return
            }
            
            self.blockchainStatisticsRequestResponseSubject.onNext(.success(transactions))
        }.resume()
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
