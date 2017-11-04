//
//  HistogramPointsChartView+Positions.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 04.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension HistogramPointsChartView {
    var pointRadius: CGFloat {
        get { return columnWidth / 4 }
    }
    func pointX(at position: Int) -> CGFloat {
        return columnX(at: position) + pointRadius
    }
    func pointY(of part: CGFloat) -> CGFloat {
        return columnY(of: part) - pointRadius
    }
    
    func pointCenter(at position: Int, of part: CGFloat) -> CGPoint{
        return CGPoint(
            x: pointX(at: position) + pointRadius,
            y: columnY(of: part)
        )
    }
    func pointCGPoint(at position: Int, of part: CGFloat) -> CGPoint {
        return CGPoint(
            x: pointX(at: position),
            y: pointY(of: part)
        )
    }
    func pointRect(at position: Int, of part: CGFloat) -> CGRect {
        return CGRect(
            x: pointX(at: position),
            y: pointY(of: part),
            width: pointRadius * 2,
            height: pointRadius * 2
        )
    }
    
}
