//
//  BitcoinQuotesViewController.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit
import RxSwift
import Cartography

final class BitcoinQuotesViewController: UIViewController {

    private var disposeBag: DisposeBag!
    private lazy var apiClient = APIClient()
    
    private lazy var titleHeaderView = TitleHeaderView.instantiateFromNib()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        applyLayout()
        bind()
    }
    
    private func applyLayout() {
        view.backgroundColor = .white
        
    }
    
    private func bind() {
        disposeBag = DisposeBag()
        
        apiClient.getBlockchainStatistics()
            .subscribe { (event) in
                switch event {
                case .success(let transactions):
                    print("TODO success \(transactions.count)")
                case .error(let error):
                    print("TODO error \(error)")
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout subviews
extension BitcoinQuotesViewController {
    
    private func addSubviews() {
        
        view.addSubview(titleHeaderView)
        constrain(view, titleHeaderView) { (container, headerView) in
            headerView.top == container.safeAreaLayoutGuide.top
            headerView.left == container.left
            headerView.right == container.right
        }
    }
}
