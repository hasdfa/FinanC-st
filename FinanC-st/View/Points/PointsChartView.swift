//
//  PointsChartView.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 04.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class PointsChartView: HistogramPointsChartView {

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        var i = 0
        let line = UIBezierPath()
        line.move(to: pointCenter(at: 0, of: columns.first?.point ?? 0.0))
        
        drawStartLineUnderPoints(on: line)
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawLine(on: line, startedAt: i, with: it.point)
        }
        drawEndLineUnderPoints(on: line)
        HCColors.colorPrimaryLight.setFill()
        line.fill()
        
        i = 0
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawLine(startedAt: i, with: it.point)
            drawLabel(on: context, at: i, and: it.lable)
            drawPoints(at: i, with: it.point)
        }
    }

}
