//
//  Transaction.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 27.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import CoreData

extension Transaction {
    
    var dateComponent: DateComponents {
        return DateComponents.initWithDate(date: self.date!)
    }
    
    var categoryType: CategoryType {
        return CategoryType(rawValue: category!)!
    }
    
    var transactionType: TransactionType {
        return TransactionType(rawValue: type!)!
    }
    
    static func createOn(_ context: NSManagedObjectContext,
                                date: DateComponents,
                                description: String,
                                value: Double,
                                type: TransactionType,
                                category: CategoryType
        ) -> Transaction {
        let transaction = Transaction(context: context)
        transaction.date = date.date
        transaction.descriptionTitle = description
        transaction.value = value
        transaction.type = type.rawValue
        transaction.category = category.rawValue
        return transaction
    }
    
}
