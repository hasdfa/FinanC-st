//
//  AddTransactionViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 24.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class AddTransactionViewController: UIViewController {

    weak var delegate: AddTransactionDelegate!
    weak var numberPadDelegate: UINumberPadDelegate!
    
    lazy var numberPad: UINumberPad = {
        return UINumberPad(frame: CGRect(
            x: 0,
            y: self.view.bounds.maxY,
            width: self.view.bounds.width,
            height: self.view.bounds.height - delegate.moneyFieldMaxY
        ))
    }()
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var isExpensesClicker = true
    var selectedColor = #colorLiteral(red: 0.5389544368, green: 0.7436622381, blue: 0.9821848273, alpha: 1)
    var unselectedText = #colorLiteral(red: 0.8078431373, green: 0.831372549, blue: 0.8549019608, alpha: 1)
    @IBAction func onExpendsClick(_ sender: UIButton) {
        if !isExpensesClicker {
            isExpensesClicker = true
            incomeButton.backgroundColor = UIColor.white
            incomeButton.setTitleColor(unselectedText, for: .normal)
            
            expensesButton.backgroundColor = selectedColor
            expensesButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBAction func onIncomeClick(_ sender: UIButton) {
        if isExpensesClicker {
            isExpensesClicker = false
            
            expensesButton.backgroundColor = UIColor.white
            expensesButton.setTitleColor(unselectedText, for: .normal)
            
            incomeButton.setTitleColor(UIColor.white, for: .normal)
            incomeButton.backgroundColor = selectedColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesButton.setCornerRadius()
        incomeButton.setCornerRadius()
        
        numberPad.delegate = numberPadDelegate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let childVC = segue.destination as? AddTransactionTableViewController,
            let id = segue.identifier,
            id == "child" {
            self.delegate = childVC
            childVC.delegate = self
            numberPadDelegate = childVC
        }
    }
}

extension AddTransactionViewController: AddTransactionDelegateCallback {
    var numberPadMarginFromTop: CGFloat {
        return (self.delegate.moneyFieldMaxY + containerView.frame.minY) * 1.05
    }
    
    func openNumericPad() {
        self.view.addSubview(numberPad)
        self.view.bringSubview(toFront: numberPad)
        UIView.animate(withDuration: 0.33) {
            self.numberPad.frame = CGRect(
                x: 0,
                y: self.numberPadMarginFromTop,
                width: self.view.bounds.width,
                height: self.view.bounds.height - self.numberPadMarginFromTop
            )
        }
    }
    func closeNumericPad() {
        UIView.animate(withDuration: 0.25, animations: {
            self.numberPad.frame = CGRect(
                x: 0,
                y: self.view.bounds.maxY,
                width: self.view.bounds.width,
                height: self.view.bounds.height - self.numberPadMarginFromTop
            )
        }) { if $0 { self.numberPad.removeFromSuperview() } }
    }
}

protocol AddTransactionDelegateCallback: NSObjectProtocol {
    func openNumericPad()
    func closeNumericPad()
}
