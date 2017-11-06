//
//  MasterViewController.swift
//  FinanC-st
//
//  Created by Vadim on 06.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class MasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HistogramViewController,
            let id = segue.identifier {
            switch id {
            case "0":
                vc.chartType = .withColumns
            case "1":
                vc.chartType = .withColumnsAndPoints
            case "2":
                vc.chartType = .withPoint
            default:
                break
            }
        }
    }

}
