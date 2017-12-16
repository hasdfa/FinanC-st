//
//  UIViewController+.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 15.12.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func showMessage(
        title: String,
        message: String? = nil,
        OkPressed: @escaping (UIAlertAction) -> Void,
        cancelPressed: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: OkPressed
        ))
        if let cancelPressed = cancelPressed {
            alertController.addAction(UIAlertAction(
                title: "Cancel",
                style: .destructive,
                handler: cancelPressed
            ))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func showError(title: String, message: String? = nil,
                          onOkPressed: @escaping ((UIAlertAction) -> Void)) {
        showMessage(title: title, message: message, OkPressed: onOkPressed)
    }
    
}
