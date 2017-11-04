//
//  HistogramPointsChartView+Draw.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 04.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

//// Draw extension
extension HistogramPointsChartView {
    
    func drawPoints(at position: Int, with value: CGFloat){
        //// OVAL Drawing
        let ovalRect = pointRect(at: position, of: value)
        let ovalPath = UIBezierPath(ovalIn: ovalRect)
        HCColors.colorPrimaryLight.setFill()
        ovalPath.fill()
        
        HCColors.colorPrimary.setStroke()
        ovalPath.lineWidth = pointRadius / 3
        ovalPath.stroke()
    }
    
    func drawLine(on line: UIBezierPath, startedAt position: Int, with value: CGFloat) {
        if position < columns.count - 1 {
            let center = pointCenter(at: position, of: value)
            
            let i2 = position + 1
            let secondCenter = pointCenter(at: i2, of: columns[i2].point)
            
            drawLine(on: line, from: center, to: secondCenter)
        }
    }
    
    
    func drawLine(on line: UIBezierPath, from start: CGPoint, to end: CGPoint,
                  with color: UIColor = HCColors.colorPrimary) {
        line.addQuadCurve(to: end, controlPoint: start)
        
        color.setStroke()
        line.lineWidth = pointRadius / 2
        line.lineCapStyle = .square
        line.stroke()
    }
    
    
    func drawLine(startedAt position: Int, with value: CGFloat) {
        if position < columns.count - 1 {
            let center = pointCenter(at: position, of: value)
            
            let i2 = position + 1
            let secondCenter = pointCenter(at: i2, of: columns[i2].point)
            
            let line = UIBezierPath()
            line.move(to: center)
            line.addLine(to: secondCenter)
            
            HCColors.colorPrimary.setStroke()
            line.lineWidth = pointRadius / 2
            line.lineCapStyle = .square
            line.stroke()
        }
    }
}
