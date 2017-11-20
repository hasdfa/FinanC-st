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
    
    public func initWith(transaction: Transaction) {
        iconImageView.image = transaction.icon.image
        titleLabel.text = transaction.icon.title
        subtitleLabel.text = transaction.description
        
//        var priceSeparretedByCommas = Int(transaction.value)
//        var priceStr = ""
//        while priceSeparretedByCommas > 0 {
//            let some = priceSeparretedByCommas % 1000
//            priceSeparretedByCommas /= 1000
//            priceStr = priceSeparretedByCommas % 10 > 0
//                ? ",\(some)"
//                : "\(some)"
//
//        }
        
        let tempPrice = "\(transaction.value )"
        //priceStr + "\(transaction.value - Double(Int(transaction.value)))"
        
        let priceNum: String
        if tempPrice.hasSuffix(".0") || tempPrice.hasSuffix(".00") {
            priceNum = "\(Int(transaction.value))"
        } else if tempPrice.indexDistance(of: ".")! == tempPrice.count - 2 {
            priceNum = tempPrice + "0"
        } else {
            priceNum = tempPrice
        }
        
        self.price.text = "$ \(priceNum)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
