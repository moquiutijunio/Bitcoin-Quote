//
//  BitcoinQuotesViewController.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift

final class BitcoinQuotesViewController: UIViewController {

    private var disposeBag: DisposeBag!
    private lazy var apiClient = APIClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        bind()
    }
    
    private func bind() {
        disposeBag = DisposeBag()
        
        apiClient.getBlockchainStatistics()
            .subscribe { (event) in
                switch event {
                case .success(let transactions):
                    print("TODO success \(transactions)")
                case .error(let error):
                    print("TODO error \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}
