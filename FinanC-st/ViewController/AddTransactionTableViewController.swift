//
//  AddTransactionTableViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 24.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class AddTransactionTableViewController: UITableViewController {
    
    weak var delegate: AddTransactionDelegateCallback!
    
    private var state: SummStates = .empty
    
    enum SummStates {
        case empty
        case number
    }
    
    @IBOutlet weak var summLabel: UILabel!
    @IBAction func clearNums(_ sender: Any) {
        if var text = summLabel.text {
            if text.count >= 1 {
                text.removeLast()
            }
            if text.count == 0 {
                text = "0"
                state = .empty
            }
            if text.count >= 1 && (text != "0" || text != ".") {
                state = .number
            }
            summLabel.text = text
        }
    }
    var summ: String {
        get {
            return summLabel?.text ?? "0"
        }
        set {
            summLabel.text = newValue
        }
    }
    
    var isOpenNumberPanel = false {
        didSet {
            if isOpenNumberPanel {
                delegate.openNumericPad()
            } else {
                delegate.closeNumericPad()
            }
        }
    }
    @IBAction func interactWithNumberPanel(_ sender: UIView) {
        isOpenNumberPanel = !isOpenNumberPanel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddTransactionTableViewController: AddTransactionDelegate {
    var money: Double {
        return Double(self.summLabel.text ?? "0.0") ?? 0.0
    }
    var category: CategoryType {
        fatalError("Not implemented")
    }
    var date: DateComponents {
        fatalError("Not implemented")
    }
    var name: String {
        fatalError("Not implemented")
    }
    var moneyFieldMaxY: CGFloat {
        return summLabel.frame.maxY
    }
}

extension AddTransactionTableViewController: UINumberPadDelegate {
    func onNumberSelect(_ numberPad: UINumberPad, number: Int) {
        if state == .empty {
            summ = "\(number)"
            state = .number
        } else {
            summ += "\(number)"
        }
    }
    func onOperationSelect(_ numberPad: UINumberPad, with: String) {
        switch with {
        case "C":
            clearNums(self)
        case "AC":
            summ = "0"
            state = .empty
        case "=":
            isOpenNumberPanel = false
            
            if summ.contains(".") || summ.all { $0 == "0" } {
                var temp = summ
                for ch in temp.reversed() {
                    if ch == "0" {
                        temp.removeLast()
                    } else if ch == "." {
                        temp.removeLast()
                        break
                    } else {
                        break
                    }
                }
                summ = temp.count == 0 ? "0" : temp
            }
        case ".":
            if !summ.contains(".") {
                if state != .empty {
                    summ += "."
                } else {
                    summ = "0."
                    state = .number
                }
            }
        case "00":
            summ += "00"
        default:
            break
        }
    }
}

extension Sequence {
    public func any(_ from: (Iterator.Element) -> Bool) -> Bool {
        for item in self {
            if from(item) {
                return true
            }
        }
        return false
    }
    public func all(_ from: (Iterator.Element) -> Bool) -> Bool {
        for item in self {
            if !from(item) {
                return false
            }
        }
        return true
    }
}

protocol AddTransactionDelegate: NSObjectProtocol {
    var money: Double { get }
    var category: CategoryType { get }
    var date: DateComponents { get }
    var name: String { get }
    var moneyFieldMaxY: CGFloat { get }
}

