//
//  ViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chartView: HistogramChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.columns = [
            HistogramColumn.init(point: 200_000, lable: "JUN"),
            HistogramColumn.init(point: 275_000, lable: "JUL"),
            HistogramColumn.init(point: 150_000, lable: "AUG"),
            HistogramColumn.init(point: 500_000, lable: "SEP"),
            HistogramColumn.init(point: 160_000, lable: "OKT"),
            HistogramColumn.init(point: 380_000, lable: "NOV"),
            HistogramColumn.init(point: 450_000, lable: "DEC")
        ]
        chartView.delegate = self
        chartView.setNeedsDisplay()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        chartView.selectedColumn = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UIHistogramChartViewDelegate {
    
    func columnDidSelect(at position: Int, with column: HistogramColumn) {
        
    }
    
    func columnDidDeselect() {
        
    }
}




