//
//  ErrorTableViewCell.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 07/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit

final class ErrorTableViewCell: UITableViewCell {
    static let reuseId = "ErrorTableViewCell"
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var refreshImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       applyAppearance()
    }
    
    private func applyAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
               
        errorLabel.font = UIFont.systemFont(ofSize: 16)
        errorLabel.textColor = .black
        errorLabel.numberOfLines = 0
        
        refreshImageView.image = UIImage(named: "ic_refresh")
        refreshImageView.contentMode = .scaleAspectFit
    }
    
    func bindIn(error: String) {
        errorLabel.text = error
    }
}
