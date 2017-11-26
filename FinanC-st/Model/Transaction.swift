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
    
}
