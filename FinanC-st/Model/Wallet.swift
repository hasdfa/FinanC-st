//
//  Wallet.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class Wallet {
    
    public var selectedMonth: Int? = nil {
        didSet {
            update()
        }
    }
    
    public var typedTransactions: [Transaction] {
        return transactions?.allObjects as! [Transaction]
    }
    
    public var transactionGoupedByDate = [Int64: [Transaction]]()
    public var dates: [DateComponents] = []

    public func update() {
        transactionGoupedByDate = [:]
        dates = []
        typedTransactions.forEach { transaction in
            if selectedMonth == nil || selectedMonth == transaction.dateComponent.month {
                let key = transaction.dateComponent.value
                if dates.contains(where: { $0.value == transaction.dateComponent.value }) {
                    transactionGoupedByDate[key]!.append(transaction)
                } else {
                    dates.append(transaction.dateComponent)
                    transactionGoupedByDate[key] = [transaction]
                }
            }
        }
        dates.sort(by: { $0.value > $1.value })
    }

    public func transactionsBy(year: Int, month: Int, day: Int) -> [Transaction] {
        return transactionsBy(
            component: DateComponents.initWith(
                year: year,
                month: month,
                day: day
            )
        )
    }
    public func transactionsBy(component: DateComponents) -> [Transaction] {
        return transactionGoupedByDate[component.value] ?? []
    }
}

public enum TransactionType: String {
    case income = "Income"
    case expenses = "Expenses"
    case unknown = "Unknown"
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
