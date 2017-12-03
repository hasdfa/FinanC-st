//
//  MonthModel.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 27.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

class MonthModel {
    init() {
        self.date = DateComponents.now
        self.title = ""
    }
    init(date: DateComponents, title: String) {
        self.date = date
        self.title = title
    }
    var date: DateComponents
    var title: String
    
    func toString() -> String {
        return "\(title): \(date)"
    }
}
