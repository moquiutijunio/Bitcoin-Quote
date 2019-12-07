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
    
    private var blockchainRequestResponse: RequestResponse<[Transaction]> = .loading {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.alwaysBounceVertical = false
        tableView.separatorColor = .clear

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: BlockchainChartViewCell.reuseId, bundle: nil), forCellReuseIdentifier: BlockchainChartViewCell.reuseId)
        return tableView
    }()
    
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
            .subscribe { [weak self] (event) in
                guard let self = self else { return }
                
                switch event {
                case .success(let transactions):
                    self.blockchainRequestResponse = .success(transactions)
                case .error(let error):
                    self.blockchainRequestResponse = .failure(error.localizedDescription)
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout subviews
extension BitcoinQuotesViewController {
    
    private func addSubviews() {
        
        view.addSubview(titleHeaderView)
        view.addSubview(tableView)
        constrain(view, titleHeaderView, tableView) { (container, headerView, tableView) in
            headerView.top == container.safeAreaLayoutGuide.top
            headerView.left == container.left
            headerView.right == container.right
            
            tableView.top == headerView.bottom
            tableView.left == container.left
            tableView.right == container.right
            tableView.bottom == container.safeAreaLayoutGuide.bottom
        }
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension BitcoinQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .success = blockchainRequestResponse else {
            return 0
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch blockchainRequestResponse {
        case .success(let transactions):
            let cell = tableView.dequeueReusableCell(withIdentifier: BlockchainChartViewCell.reuseId, for: indexPath) as! BlockchainChartViewCell
            cell.bindIn(transactions: transactions)
            return cell

        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .failure = blockchainRequestResponse else { return }
        
        //TODO try again request
    }
}
