//
//  Wallet.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class Wallet {
    
    init(_ name: String, summ: Double, income: Double, expense: Double) {
        self.name = name
        self.averageSumm = summ
        self.income = income
        self.expense = expense
    }
    
    var name: String
    var averageSumm: Double
    var income: Double
    var expense: Double
}

class WalletBlueScheme: WalletColorStyle {
    static var backgroundColor: UIColor = HCColors.colorPrimary
    static var textColor: UIColor = .white
}
class WalletGrayScheme: WalletColorStyle {
    static var backgroundColor: UIColor = #colorLiteral(red: 0.9333333333, green: 0.9529411765, blue: 0.9725490196, alpha: 1)
    static var textColor: UIColor = #colorLiteral(red: 0.4862745098, green: 0.5137254902, blue: 0.537254902, alpha: 1)
}

protocol WalletColorStyle {
    static var backgroundColor: UIColor { get }
    static var textColor: UIColor { get }
}
