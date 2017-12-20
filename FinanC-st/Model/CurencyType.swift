//
//  CurencyType.swift
//  FinanC-st
//
//  Created by Vadim on 20.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

public enum CurrencyType: String {
    case dollar = "$"
    case euro = "€"
    case hryvnas = "₴"
    
    public static let all: [CurrencyType] = [.dollar, .euro, .hryvnas]
}
