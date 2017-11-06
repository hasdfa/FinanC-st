//
//  HistogramChartView+Positions.swift
//  Charts
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension HistogramChartView {
    var maxPoint: CGFloat {
        get {
            return CGFloat(columns.max(by: {
                $0.point < $1.point
            })?.point ?? 0.0)
        }
    }
    
    // MARK: Histogram Chart size
    var width: CGFloat { get { return self.frame.width - marginLeftRight } }
    var height: CGFloat { get { return self.frame.height - marginTopDown } }
    
    
    // MARK: Column Space size
    var columnSpaceWidth: CGFloat {
        get { return (width - getPercent(10, of: width)) / CGFloat(columns.count) }
    }
    var columnSpaceHeight: CGFloat {
        get { return height - getPercent(15, of: height) }
    }
    func columnSpaceX(at position: Int) -> CGFloat {
        return getPercent(5, of: width) +
            columnSpaceWidth * CGFloat(position)
    }
    
    
    // MARK: margins
    var marginTopDown: CGFloat {
        get { return getPercent(5, of: self.frame.height) }
    }
    var marginLeftRight: CGFloat {
        get { return getPercent(5, of: self.frame.width) }
    }
    var marginTopFromMax: CGFloat {
        get { return getPercent(5, of: height) }
    }
    
    
    // MARK: Column position
    func columnHeight(of part: CGFloat) -> CGFloat {
        return getPercent(75, of: height) * (part / maxPoint)
    }
    var columnWidth: CGFloat {
        get { return getPercent(HCConst.columnWidthPercent, of: columnSpaceWidth) }
    }
    func columnY(of part: CGFloat) -> CGFloat {
        return getPercent(10, of: height)
            + marginTopDown
            + columnHeight(of: maxPoint - part)
    }
    func columnX(at position: Int) -> CGFloat {
        return getPercent(5, of: width) +
            (columnSpaceWidth-columnWidth)/2 +
            columnSpaceWidth * CGFloat(position)
    }
    
    // MARK: Column rect
    func columnRect(at position: Int, of part: CGFloat) -> CGRect {
        return CGRect(
            x: columnX(at: position),
            y: columnY(of: part),
            width: columnWidth,
            height: columnHeight(of: part)
        )
    }
    // MARK: Column Background rect
    func columnBackgroundRect(at position: Int) -> CGRect {
        return CGRect(
            x: lableX(at: position),
            y: columnY(of: maxPoint) - getPercent(2.5, of: height),
            width: columnSpaceWidth,
            height: columnSpaceHeight + getPercent(5, of: height)
        )
    }
    
    
    // MARK: lable position
    var lableHeight: CGFloat {
        get { return getPercent(10, of: height) }
    }
    var lableWidth: CGFloat {
        get { return columnSpaceWidth }
    }
    func lableY() -> CGFloat {
        return getPercent(85, of: height) + marginTopDown
    }
    func lableX(at position: Int) -> CGFloat {
        return getPercent(5, of: width) +
            columnSpaceWidth * CGFloat(position)
    }
    
    // MARK: lable rect
    func lableRect(at position: Int) -> CGRect {
        return CGRect(
            x: lableX(at: position),
            y: lableY(),
            width: lableWidth,
            height: lableHeight
        )
    }
}


// MARK: Points
extension HistogramChartView {
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


// MARK: Utils
extension HistogramChartView {
    func getPercent(_ percent: Double, of number: CGFloat) -> CGFloat {
        return number * CGFloat(percent) / 100
    }
}
