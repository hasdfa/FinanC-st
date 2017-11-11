//
//  UIHistogramChartViewDelegate.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import Foundation

protocol UIHistogramChartViewDelegate: NSObjectProtocol {
    func columnDidSelect(at position: Int, with column: HistogramColumn)
    func columnDidDeselect(at position: Int?)
}
