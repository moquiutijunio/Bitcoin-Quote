//
//  TitleHeaderView.swift
//  bitcoinquotes
//
//  Created by Junio Moquiuti on 06/12/19.
//  Copyright © 2019 Junio Moquiuti. All rights reserved.
//

import UIKit

final class TitleHeaderView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var fontLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        applyLayout()
    }
    
    private func applyLayout() {
        backgroundColor = .clear
    
        titleLabel.text = NSLocalizedString("market.price", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        infoLabel.text = NSLocalizedString("info.blockchain", comment: "")
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.textColor = .black
        
        fontLabel.text = NSLocalizedString("source.blockchain", comment: "")
        fontLabel.font = UIFont.systemFont(ofSize: 12)
        fontLabel.textAlignment = .center
        fontLabel.textColor = .black
    }
}

// MARK: - UINib
extension TitleHeaderView {
    
    class func instantiateFromNib() -> TitleHeaderView {
        return UINib(nibName: "TitleHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! TitleHeaderView
    }
}
