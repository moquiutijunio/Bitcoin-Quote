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
    var currentTimespan: Timespan = .allTime
    
    private lazy var apiClient: APIClientProtocol = APIClient()
    private lazy var titleHeaderView = TitleHeaderView.instantiateFromNib()
    private lazy var chartDurationView = ChartDurationView.instantiateFromNib(viewModel: self)
    
    private var blockchainRequestResponse: RequestResponse<[Transaction]> = .loading {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.alwaysBounceVertical = false
        tableView.separatorColor = .clear

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: BlockchainChartViewCell.reuseId, bundle: nil), forCellReuseIdentifier: BlockchainChartViewCell.reuseId)
        tableView.register(UINib(nibName: LoadingTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: LoadingTableViewCell.reuseId)
        tableView.register(UINib(nibName: ErrorTableViewCell.reuseId, bundle: nil), forCellReuseIdentifier: ErrorTableViewCell.reuseId)
        return tableView
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        addSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        bind()
        applyLayout()
        apiClient.getBlockchainStatistics(timespan: currentTimespan.key)
    }
    
    private func applyLayout() {
        view.backgroundColor = .white
    }
    
    private func bind() {
        disposeBag = DisposeBag()
        
        apiClient.blockchainStatisticsRequestResponse
            .subscribe(onNext: { [unowned self] (response) in
                self.blockchainRequestResponse = response
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Layout subviews
extension BitcoinQuotesViewController {
    
    private func addSubviews() {
        
        view.addSubview(titleHeaderView)
        view.addSubview(chartDurationView)
        view.addSubview(tableView)
        constrain(view, titleHeaderView, chartDurationView, tableView) { (container, headerView, durationView, tableView) in
            headerView.top == container.safeAreaLayoutGuide.top
            headerView.left == container.left
            headerView.right == container.right
            
            durationView.top == headerView.bottom
            durationView.left == container.left
            durationView.right == container.right
            
            tableView.top == durationView.bottom
            tableView.left == container.left
            tableView.right == container.right
            tableView.bottom == container.safeAreaLayoutGuide.bottom
        }
    }
}

// MARK: - ChartDurationViewModelProtocol
extension BitcoinQuotesViewController: ChartDurationViewModelProtocol {
    
    func durationSegmentedDidTap() {
        apiClient.getBlockchainStatistics(timespan: currentTimespan.key)
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension BitcoinQuotesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch blockchainRequestResponse {
        case .success(let transactions):
            let cell = tableView.dequeueReusableCell(withIdentifier: BlockchainChartViewCell.reuseId, for: indexPath) as! BlockchainChartViewCell
            cell.bindIn(transactions: transactions)
            return cell

        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.reuseId, for: indexPath) as! LoadingTableViewCell
            return cell
            
        case .failure(let error):
            let cell = tableView.dequeueReusableCell(withIdentifier: ErrorTableViewCell.reuseId, for: indexPath) as! ErrorTableViewCell
            cell.bindIn(error: error)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case .failure = blockchainRequestResponse else { return }
        apiClient.getBlockchainStatistics(timespan: currentTimespan.key)
    }
}
