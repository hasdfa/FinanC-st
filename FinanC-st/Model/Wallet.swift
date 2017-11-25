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
    
    var updateHandler: (() -> Void)? = nil
    
    var name: String
    var averageSumm: Double
    var income: Double
    var expense: Double
    
    var selectedMonth: Int? = nil {
        didSet {
            update()
        }
    }
    
    var transactions: [Transaction] = [] {
        didSet {
            update()
        }
    }
    
    var transactionGoupedByDate = [Int64: [Transaction]]()
    var dates: [DateComponents] = []
    
    private func update() {
        transactionGoupedByDate = [:]
        dates = []
        transactions.forEach { transaction in
            if let selected = self.selectedMonth,
                selected != transaction.date.month {
                
            } else {
                let key = transaction.date.value
                if dates.contains(where: { $0.value == transaction.date.value }) {
                    transactionGoupedByDate[key]!.append(transaction)
                } else {
                    dates.append(transaction.date)
                    transactionGoupedByDate[key] = [transaction]
                }
                
            }
        }
        dates.sort(by: { $0.value > $1.value })
        updateHandler?()
    }
    
    func transactionsBy(year: Int, month: Int, day: Int) -> [Transaction] {
        return transactionsBy(
            component: DateComponents.initWith(
                year: year,
                month: month,
                day: day
            )
        )
    }
    func transactionsBy(component: DateComponents) -> [Transaction] {
        return transactionGoupedByDate[component.value] ?? []
    }
}

class Transaction {
    
    init() {
        self.description = ""
        self.icon = .null
        self.type = .unknown
        date = DateComponents.now
        self.value = 0
    }
    
    init(description: String, icon: CategoryType, type: TransactionType, value: Double, date: DateComponents = DateComponents.now) {
        self.description = description
        self.icon = icon
        self.type = type
        self.date = date
        self.value = value
    }
    
    var description: String
    
    var icon: CategoryType
    var type: TransactionType
    
    var date: DateComponents
    
    var value: Double
}

enum TransactionType: String {
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
