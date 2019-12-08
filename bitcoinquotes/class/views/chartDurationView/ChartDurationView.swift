//
//  ChartDurationView.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 08/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit

enum Timespan: Int, CaseIterable {
    
    case thirtyDays
    case sixtyDays
    case hundredEightyDays
    case oneYear
    case twoYears
    case allTime
    
    var title: String {
        switch self {
        case .thirtyDays: return NSLocalizedString("thirty.days", comment: "")
        case .sixtyDays: return NSLocalizedString("sixty.days", comment: "")
        case .hundredEightyDays: return NSLocalizedString("hundred.eighty.days", comment: "")
        case .oneYear: return NSLocalizedString("one.year", comment: "")
        case .twoYears: return NSLocalizedString("two.years", comment: "")
        case .allTime: return NSLocalizedString("all.time", comment: "")
        }
    }
    
    var key: String {
        switch self {
        case .thirtyDays: return "30days"
        case .sixtyDays: return "60days"
        case .hundredEightyDays: return "180days"
        case .oneYear: return "1year"
        case .twoYears: return "2years"
        case .allTime: return "all"
        }
    }
}

protocol ChartDurationViewModelProtocol {
    
    var currentTimespan: Timespan { get set }
    
    func durationSegmentedDidTap()
}

final class ChartDurationView: UIView {
    
    @IBOutlet weak var durationSegmentedControl: UISegmentedControl!
    
    private var viewModel: ChartDurationViewModelProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
        
        durationSegmentedControl.backgroundColor = .white
        durationSegmentedControl.selectedSegmentTintColor = .primaryColor
        durationSegmentedControl.apportionsSegmentWidthsByContent = true
        durationSegmentedControl.removeAllSegments()
        
        for (index, timespan) in Timespan.allCases.enumerated() {
            durationSegmentedControl.insertSegment(withTitle: timespan.title, at: index, animated: true)
        }
    }
    
    private func bindIn(viewModel: ChartDurationViewModelProtocol) {
        
        durationSegmentedControl.selectedSegmentIndex = viewModel.currentTimespan.rawValue
        self.viewModel = viewModel
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        viewModel?.currentTimespan = Timespan.allCases[durationSegmentedControl.selectedSegmentIndex]
        viewModel?.durationSegmentedDidTap()
    }
}

// MARK: - UINib
extension ChartDurationView {
    
    class func instantiateFromNib(viewModel: ChartDurationViewModelProtocol) -> ChartDurationView {
        let view =  UINib(nibName: "ChartDurationView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! ChartDurationView
        view.bindIn(viewModel: viewModel)
        return view
    }
}
