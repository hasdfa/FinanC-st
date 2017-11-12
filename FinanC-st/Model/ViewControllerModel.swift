//
//  ViewControllerModel.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 12.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class ViewControllerModel {
    
    init(id: String, title: String, image: UIImage) {
        self.storyboardId = id
        self.itemTitle = title
        self.itemImage = image
    }
    
    var storyboardId: String!
    
    var itemImage: UIImage!
    var itemTitle: String!
    
}
