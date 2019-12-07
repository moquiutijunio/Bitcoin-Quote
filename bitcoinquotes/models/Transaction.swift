//
//  Transaction.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import Foundation

struct Transaction: Codable {
    
    var miliseconds: Int
    var value: Double
    
    enum CodingKeys: String, CodingKey {
        case miliseconds = "x"
        case value = "y"
    }
}

extension Transaction {
    
    static func map(json: Any) -> Transaction? {
        guard let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) ,
            let transaction = try? JSONDecoder().decode(Transaction.self, from: data) else {
                return nil
        }
        
        return transaction
    }
    
    static func mapArray(data: Data) -> [Transaction]? {
        guard let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary,
            let transactionsJson = jsonObj.value(forKey: "values") as? NSArray else {
            return nil
        }
        
        return transactionsJson
            .compactMap { Transaction.map(json: $0) }
    }
}
