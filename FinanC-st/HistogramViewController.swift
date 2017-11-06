//
//  HistogramViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class HistogramViewController: UIViewController {

    @IBOutlet weak var chartView: HistogramChartView! {
        didSet {
            chartView.chartType = chartType
        }
    }
    
    public var chartType: HistogramChartType = .withColumns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.columns = [
            HistogramColumn(point: 200_000, lable: "JUN"),
            HistogramColumn(point: 275_000, lable: "JUL"),
            HistogramColumn(point: 150_000, lable: "AUG"),
            HistogramColumn(point: 500_000, lable: "SEP"),
            HistogramColumn(point: 160_000, lable: "OKT"),
            HistogramColumn(point: 380_000, lable: "NOV"),
            HistogramColumn(point: 450_000, lable: "DEC")
        ]
        chartView.delegate = self
    }
}

extension HistogramViewController: UIHistogramChartViewDelegate {
    
    func columnDidSelect(at position: Int, with column: HistogramColumn) {
        
    }
    
    func columnDidDeselect() {
        
    }
}




