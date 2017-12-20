//
//  CategoryType.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 21.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

enum CategoryType: String {
    case rent = "Rent"
    case bill = "Bill"
    case insurance = "Insurance"
    case utilites = "Utilites"
    case electronics = "Electronics"
    case clothing = "Clothings"
    case gadgets = "Gadgets"
    case savings = "Savings"
    
    var title: String {
        return self.rawValue
    }
    
    static let all: [CategoryType] = [
        .rent,
        .bill,
        .insurance,
        .utilites,
        .electronics,
        .clothing,
        .gadgets,
        .savings
    ]
    
    var image: UIImage {
        switch self {
        case .rent: return #imageLiteral(resourceName: "rent")
        case .bill: return #imageLiteral(resourceName: "bill")
        case .insurance: return #imageLiteral(resourceName: "insurance")
        case .utilites: return #imageLiteral(resourceName: "utilites")
        case .electronics: return #imageLiteral(resourceName: "electronics")
        case .clothing: return #imageLiteral(resourceName: "clothing")
        case .gadgets: return #imageLiteral(resourceName: "gadget")
        case .savings: return #imageLiteral(resourceName: "savings")
        }
    }
}
