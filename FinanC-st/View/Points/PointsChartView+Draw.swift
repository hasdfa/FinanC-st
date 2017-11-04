//
//  PointsChartView+Draw.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 04.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

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
