//
//  ViewExtensions.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 07/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit

// MARK: - Int
extension Int {
    
    var toDouble: Double {
        return Double(self)
    }
}

// MARK: - Date
extension Date {
    
    func stringWith(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
