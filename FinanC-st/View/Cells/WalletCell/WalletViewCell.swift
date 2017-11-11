//
//  WalletViewCell.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class WalletViewCell: UICollectionViewCell {
    
    public var isSelectedWallet: Bool = false {
        didSet {
            if isSelectedWallet {
                onSelect()
            } else {
                onDeselect()
            }
        }
    }
    
    @IBOutlet weak var cardBackground: UIView!
    @IBOutlet weak var walletTitle: UILabel!
    @IBOutlet weak var averageSumm: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    public func initWith(wallet: Wallet) {
        walletTitle.text = wallet.name
        averageSumm.text = "$\(Int(wallet.averageSumm))"
        
        let get: (Double) -> String = { double in
            if double >= 1_000_000_000 || double <= -1_000_000_000 {
                return "$\(Int(double/1000))KKK"
            } else if double >= 1_000_000 || double <= -1_000_000 {
                return "$\(Int(double/1000))M" // KK
            } else if double >= 1_000 || double <= -1_000 {
                return "$\(Int(double/1000))K"
            }
            return "$\(Int(double))"
        }
        
        expenseLabel.text = get(wallet.expense)
        incomeLabel.text = get(wallet.income)
        
        cardBackground.clipsToBounds = false
        cardBackground.layer.cornerRadius = 8
    }
    
    private func onSelect() {
        
        cardBackground.backgroundColor = WalletBlueScheme.backgroundColor
        walletTitle.textColor = WalletBlueScheme.textColor
        averageSumm.textColor = WalletBlueScheme.textColor
        incomeLabel.textColor = WalletBlueScheme.textColor
        expenseLabel.textColor = WalletBlueScheme.textColor
    }
    
    private func onDeselect() {
        
        cardBackground.backgroundColor = WalletGrayScheme.backgroundColor
        walletTitle.textColor = WalletGrayScheme.textColor
        averageSumm.textColor = WalletGrayScheme.textColor
        incomeLabel.textColor = WalletGrayScheme.textColor
        expenseLabel.textColor = WalletGrayScheme.textColor
    }
}
