//
//  String+.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 27.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

extension String {
    func indexDistance(of character: Character) -> Int? {
        guard let index = index(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
}
