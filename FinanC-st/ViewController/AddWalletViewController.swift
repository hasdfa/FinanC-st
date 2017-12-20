//
//  AddWalletViewController.swift
//  FinanC-st
//
//  Created by Vadim on 20.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class AddWalletViewController: UIViewController {

    @IBOutlet weak var walletBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UITextField!
    
    @IBOutlet weak var currencyControl: UISegmentedControl!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClick(_ sender: UIButton) {
        let wallet = Wallet(context: viewContext)
        wallet.title = titleLabel.text
        wallet.currency = CurrencyType
            .all[currencyControl.selectedSegmentIndex]
            .rawValue
        try! viewContext.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        walletBackgroundView.clipsToBounds = false
        walletBackgroundView.layer.cornerRadius = 12
        
        addButton.setCornerRadius()
    }
}
