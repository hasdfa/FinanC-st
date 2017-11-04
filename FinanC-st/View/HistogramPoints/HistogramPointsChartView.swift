//
//  HistogramPointsChartView.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 04.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class HistogramPointsChartView: HistogramChartView {
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        isSelectable = false
        defaultColumnsColor = HCColors.colorPrimaryLight
        super.draw(rect)
        
        var i = 0
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawLine(startedAt: i, with: it.point)
            drawPoints(at: i, with: it.point)
        }
    }
}
