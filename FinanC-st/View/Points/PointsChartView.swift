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

//// Draw extension
extension PointsChartView {
    
    func drawStartLineUnderPoints(on line: UIBezierPath) {
        if columns.count == 0 { return }
        let firstPointCenter = pointCenter(
            at: 0,
            of: columns.first!.point
        )
        let firstBottomPoint = pointCenter(at: 0, of: 0)
        
        line.move(to: firstBottomPoint)
        drawLine(
            on: line,
            from: firstBottomPoint,
            to: firstPointCenter,
            with: HCColors.colorPrimaryLight
        )
    }
    
    func drawEndLineUnderPoints(on line: UIBezierPath) {
        if columns.count == 0 { return }
        let lastPointCenter = pointCenter(
            at: columns.count - 1,
            of: columns.last!.point
        )
        let lastBottomPoint = pointCenter(at: columns.count - 1, of: 0)
        let firstBottomPoint = pointCenter(at: 0, of: 0)
        drawLine(
            on: line,
            from: lastPointCenter,
            to: lastBottomPoint,
            with: HCColors.colorPrimaryLight
        )
        drawLine(
            on: line,
            from: lastBottomPoint,
            to: firstBottomPoint,
            with: HCColors.colorPrimaryLight
        )
    }
}
