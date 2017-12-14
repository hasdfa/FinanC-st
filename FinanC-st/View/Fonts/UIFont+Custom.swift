//
//  UIFont+Custom.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 08.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension UIFont {
    
    public static func montesrrat(ofSize size: CGFloat,
            ofType type: MontesrratFontType = .regular
        ) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
    
}
