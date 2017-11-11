//
//  DrawerViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class DrawerViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //  Converted to Swift 4 with Swiftify v1.0.6519 - https://objectivec2swift.com/
    //To add child VC
    
    func displayContentController(_ content: UIViewController) {
        addChildViewController(content)
        content.view.frame = containerView?.bounds ?? CGRect.zero
        containerView?.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    //To remove child VC
    func hideContentController(_ content: UIViewController) {
        content.willMove(toParentViewController: nil)
        content.view.removeFromSuperview()
        content.removeFromParentViewController()
    }


}
