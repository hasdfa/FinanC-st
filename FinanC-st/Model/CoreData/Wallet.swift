//
//  Wallet.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit
import CoreData

public class Wallet: NSManagedObject {
    
    public var selectedMonth: Int? = nil {
        didSet {
            update()
        }
    }
    
    public var allMoney: Double {
        var money: Double = 0
        typedTransactions.forEach {
            money += $0.transactionType == .income ? ($0.value) : (-$0.value)
        }
        return money
    }
    
    public var expensesAtAllTime: Double {
        var money: Double = 0
        typedTransactions.forEach {
            money += $0.transactionType == .expenses
                ? $0.value
                : 0
        }
        return money
    }
    public var incomesAtAllTime: Double {
        var money: Double = 0
        typedTransactions.forEach {
            money += $0.transactionType == .expenses
                ? $0.value
                : 0
        }
        return money
    }
    
    func expense(on date: DateComponents) -> HistogramColumn {
        var expensesIn: Double = 0
        typedTransactions.forEach { transaction in
            if date.value == transaction.dateComponent.value,
                transaction.transactionType == .expenses {
                expensesIn += transaction.value
            }
        }
        return HistogramColumn(point: CGFloat(expensesIn), lable: date.shortMonthName!)
    }
    var expenses: [HistogramColumn] {
        return dates.map { expense(on: $0) }
    }
    
    func income(on date: DateComponents) -> HistogramColumn {
        var incomeIn: Double = 0
        typedTransactions.forEach { transaction in
            if date.value == transaction.dateComponent.value,
                transaction.transactionType == .income {
                incomeIn += transaction.value
            }
        }
        return HistogramColumn(point: CGFloat(incomeIn), lable: date.shortMonthName!)
    }
    var incomes: [HistogramColumn] {
        return dates.map { income(on: $0) }
    }
    
    
    public var typedTransactions: [Transaction] {
        return transactions?.allObjects as! [Transaction]
    }
    public var max: Double? {
        return typedTransactions.map { $0.value }.max()
    }
    
    public var transactionGoupedByDate = [Int64: [Transaction]]()
    private var _dates: [DateComponents] = []
    public var dates: [DateComponents] {
        get {
            if !isInit { update() }
            return _dates
        }
    }

    private var isInit: Bool = false
    public func update() {
        isInit = true
        transactionGoupedByDate = [:]
        _dates = []
        typedTransactions.forEach { transaction in
            if selectedMonth == nil || selectedMonth == transaction.dateComponent.month {
                let key = transaction.dateComponent.value
                if _dates.contains(where: { $0.value == transaction.dateComponent.value }) {
                    transactionGoupedByDate[key]!.append(transaction)
                } else {
                    _dates.append(transaction.dateComponent)
                    transactionGoupedByDate[key] = [transaction]
                }
            }
        }
        _dates.sort(by: { $0.value > $1.value })
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
