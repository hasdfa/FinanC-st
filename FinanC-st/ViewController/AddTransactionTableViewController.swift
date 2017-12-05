//
//  AddTransactionTableViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 24.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class AddTransactionTableViewController: UITableViewController {
    
    private var _category: CategoryType = .rent
    
    weak var delegate: AddTransactionDelegateCallback!
    
    private var state: SummStates = .empty
    
    enum SummStates {
        case empty
        case number
    }
    
    
    @IBOutlet weak var dateLabel: UILabel!
    private var dateComponent: DateComponents = .now {
        didSet {
            dateLabel.text = "\(dateComponent.shortMonthName!.uppercased()), \(dateComponent.day!) \(dateComponent.year!)"
        }
    }
    
    @IBAction func openDateSelector(_ sender: UIButton) {
        let dateDialog = DatePickerDialog(
            textColor: .black,
            buttonColor: .black,
            font: UIFont.withMontesrrat(ofSize: 14, ofType: .semiBold),
            locale: Locale.current,
            showCancelButton: false
        )
        
        let now = DateComponents.now
        let minimumDate = DateComponents.initWith(
            year: now.year!,
            month: now.month! - 3,
            day: now.day!
        )
        
        dateDialog.show("Select transaction date",
                        defaultDate: dateComponent.date!, minimumDate: minimumDate.date,
                        callback: { date in
            if let date = date {
                self.dateComponent = DateComponents.initWithDate(date: date)
            }
        })
    }
    
    @IBOutlet weak var titleIconLeading: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UITextField! {
        didSet { titleLabel?.delegate = self }
    }
    
    @IBOutlet weak var summLabel: UILabel!
    @IBAction func clearNums(_ sender: Any) {
        if var text = summLabel.text {
            if text.count >= 1 {
                text.removeLast()
            }
            if text.count == 0 || text == "0" {
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
    
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateComponent = .now
    }
    
    var isTitleEditing = false
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "select-category",
            let selectCategory = segue.destination as? SelectCategoryViewController {
            selectCategory.onSelect = { [weak self] category in
                self?._category = category
                self?.categoryLabel?.text = category.title
                self?.categoryImage?.image = category.image
            }
        }
    }
}

extension AddTransactionTableViewController: AddTransactionDelegate {
    var money: Double {
        return Double(self.summLabel.text!
            .replacingOccurrences(of: ",", with: ""))!
    }
    var category: CategoryType {
        return _category
    }
    var date: DateComponents {
        return dateComponent
    }
    var name: String {
        return titleLabel.text ?? ""
    }
    var moneyFieldMaxY: CGFloat {
        return summLabel.frame.maxY
    }
}

extension AddTransactionTableViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isTitleEditing { return false }
        isTitleEditing = true
        self.titleIconLeading.constant = -40
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if !isTitleEditing { return false }
        isTitleEditing = false
        self.titleIconLeading.constant = 16
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            !text.isEmpty, text.count > 3 {
            textField.resignFirstResponder()
            return true
        }
        return false
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
            summ = Double(summ)!.toString()
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

extension Double {
    
    public func toString() -> String {
        var str = "\(self)"
        
        if str.contains(".") || str.starts(with: "0") || str.all { $0 == "0" } {
            var temp = str
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
            for ch in temp {
                
                if ch == "0" {
                    temp.removeFirst()
                } else if ch == "." {
                    temp = "0\(temp)"
                    break
                } else {
                    break
                }
            }
            str = temp.count == 0 ? "0" : temp
        }
        
        let dotPos = str.indexDistance(of: ".") ?? -1
        var i = str.count - 1
        var j = 0
        var temp = ""
        for char in str.reversed() {
            defer {
                temp += String(char)
                i -= 1
            }
            if i > dotPos {
                if j % 3 == 0 && j != 0 {
                    temp += ","
                }
                j += 1
            }
        }
        
        return String(temp.reversed())
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

