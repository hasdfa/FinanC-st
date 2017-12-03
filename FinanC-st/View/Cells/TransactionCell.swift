//
//  TransactionCell.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 18.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var typeIcon: UIImageView!
    
    
    public func initWith(transaction: Transaction) {
        iconImageView.image = transaction.categoryType.image
        titleLabel.text = transaction.categoryType.title
        subtitleLabel.text = transaction.descriptionTitle
        
        self.price.text = "$ \(transaction.value.toString())"
        
        typeIcon.image = transaction.transactionType == .expenses
            ? #imageLiteral(resourceName: "expenses_minus") : #imageLiteral(resourceName: "income_plus")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
