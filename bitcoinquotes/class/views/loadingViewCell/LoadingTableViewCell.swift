//
//  LoadingTableViewCell.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 07/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit

final class LoadingTableViewCell: UITableViewCell {
    static let reuseId = "LoadingTableViewCell"
    
    @IBOutlet weak var activityIndicationView: UIActivityIndicatorView!
    @IBOutlet weak var loadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyAppearance()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        activityIndicationView.startAnimating()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
        
        loadingLabel.text = NSLocalizedString("loading", comment: "")
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.systemFont(ofSize: 16)
        loadingLabel.textColor = .black
        loadingLabel.numberOfLines = 0
        
        activityIndicationView.color = .black
    }
}
