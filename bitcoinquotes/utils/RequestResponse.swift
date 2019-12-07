//
//  RequestResponse.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

enum RequestResponse<T> {
    
    case new
    case loading
    case success(T)
    case failure(String)
}
