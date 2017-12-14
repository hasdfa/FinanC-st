//
//  HistogramChartView+Draw.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension HistogramChartView {
    
    func drawColumn(on context: CGContext, with column: HistogramColumn, at position: Int, from startColumnOrNil: HistogramColumn? = nil) {
        let columnBaseRect = columnRect(at: position, of: column.point, in: columns)
        
        let start: CGRect
        if let startColumn = startColumnOrNil {
            start = columnRect(at: position, of: startColumn.point, in: oldColumns)
        } else {
            start = CGRect(
                x: columnBaseRect.minX,
                y: columnBaseRect.maxY,
                width: columnBaseRect.width,
                height: 0
            )
        }
        
        let startColumnPath = UIBezierPath(roundedRect: start, cornerRadius: 2).cgPath
        let endColumnPath = UIBezierPath(roundedRect: columnBaseRect, cornerRadius: 2).cgPath
        
        let fillColor: UIColor
        if index == -1 {
            fillColor = defaultColumnsColor
        } else {
            if index == position {
                drawSelectedBackground(on: context, at: position)
                // drawPointer(on: context, with: column.lable)

                fillColor = HCColors.colorPrimary
            } else {
                fillColor = HCColors.colorPrimaryLight
            }
        }
        
        let shape = CAShapeLayer()
        layer.addSublayer(shape)
        
        shape.fillColor = fillColor.cgColor
        if needsAnimating {
            shape.path = startColumnPath
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = 0.75
            animation.fromValue = startColumnPath
            animation.toValue = endColumnPath
            
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            
            shape.add(animation, forKey: animation.keyPath)
        } else {
            shape.path = endColumnPath
        }
    }
    
     func drawSelectedBackground(on context: CGContext , at position: Int){
        let rect = columnBackgroundRect(at: position)
        let columnPath = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        context.saveGState()
        context.setShadow(
            offset: CGSize(width: 0, height: 0),
            blur: 14,
            color: UIColor.black.withAlphaComponent(0.1).cgColor
        )
        HCColors.white.setFill()
        columnPath.fill()
        context.restoreGState()
    }
    
    func drawLabel(on context: CGContext, at position: Int, and text: String) {
        let frame = lableRect(at: position)
        drawLable(on: context, with: frame, and: text)
    }
    
    func drawLable(on context: CGContext, with frame: CGRect, and text: String,
                   color: UIColor = HCColors.colorGraySecondary, fontSize: CGFloat = 14) {
        //// Lable Drawing
        let lableTextContent = text
        let lableStyle = NSMutableParagraphStyle()
        lableStyle.alignment = .center
        let lableFontAttributes = [
            .font: UIFont.montesrrat(ofSize: fontSize, ofType: .bold),
            .foregroundColor: color,
            .paragraphStyle: lableStyle,
            ] as [NSAttributedStringKey: Any]
        
        let lableTextHeight: CGFloat = lableTextContent.boundingRect(
            with: CGSize(
                width: frame.width,
                height: frame.height
            ),
            options: .usesLineFragmentOrigin,
            attributes: lableFontAttributes,
            context: nil).height
        
        context.saveGState()
        context.clip(to: frame)
        lableTextContent.draw(in: CGRect(
            x: frame.minX,
            y: frame.minY + (frame.height - lableTextHeight) / 2,
            width: frame.width,
            height: lableTextHeight
        ), withAttributes: lableFontAttributes)
        context.restoreGState()
    }
    
    
    // TODO: Fix coordinates
    func drawPointer(on context: CGContext, with text: String) {
        //// Pointer Drawing
        let pointerPath = UIBezierPath()
        pointerPath.move(to: CGPoint(x: 99.97, y: 5))
        pointerPath.addLine(to: CGPoint(x: 130, y: 5))
        pointerPath.addLine(to: CGPoint(x: 130, y: 17))
        pointerPath.addLine(to: CGPoint(x: 105, y: 17))
        pointerPath.addCurve(to: CGPoint(x: 105, y: 8.99), controlPoint1: CGPoint(x: 105, y: 14.95), controlPoint2: CGPoint(x: 105, y: 12.27))
        pointerPath.addCurve(to: CGPoint(x: 99.97, y: 5), controlPoint1: CGPoint(x: 101.64, y: 6.33), controlPoint2: CGPoint(x: 99.97, y: 5))
        pointerPath.close()
        pointerPath.usesEvenOddFillRule = true
        HCColors.colorPrimary.setFill()
        pointerPath.fill()
        
//        let pointerLableRect = CGRect()
//        drawLable(on: context, at: , and: "")
    }
}


// MARK: Points Draw
extension HistogramChartView {
    
    func drawPoints(at position: Int, with value: CGFloat, from oldValue: CGFloat? = nil){
        //// OVAL Drawing
        let startOvalRect: CGRect
        if let old = oldValue {
            startOvalRect = pointRect(at: position, of: old, in: columns)
        } else {
            startOvalRect = pointRect(at: position, of: 0, in: columns)
        }
        let endOvalRect = pointRect(at: position, of: value, in: columns)
        
        let startPointPath = UIBezierPath(ovalIn: startOvalRect).cgPath
        let endPointPath = UIBezierPath(ovalIn: endOvalRect).cgPath
        
        let shape = CAShapeLayer()
        layer.addSublayer(shape)
        
        shape.fillColor = HCColors.colorPrimaryLight.cgColor
        shape.lineWidth = pointRadius / 3
        shape.strokeColor = HCColors.colorPrimary.cgColor
        
        if needsAnimating {
            shape.path = startPointPath
            
            let animation = CABasicAnimation(keyPath: "path")
            animation.duration = needsAnimating ? 0.75 : 0
            animation.fromValue = startPointPath
            animation.toValue = endPointPath
            
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            animation.fillMode = kCAFillModeBoth
            animation.isRemovedOnCompletion = false
            
            shape.add(animation, forKey: animation.keyPath)
        } else {
            shape.path = endPointPath
        }
    }
    
    func drawLine(on line: UIBezierPath, startedAt position: Int, with value: CGFloat) {
        if position < columns.count - 1 {
            let center = pointCenter(at: position, of: value, in: columns)
            
            let i2 = position + 1
            let secondCenter = pointCenter(at: i2, of: columns[i2].point, in: columns)
            
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
    
    func drawLinesPlace(columns: [HistogramColumn?]) -> CGPath {
        let line = UIBezierPath()
        line.move(to: pointCenter(at: 0, of: columns.first??.point ?? 0.0, in: columns))
        
        (1..<self.columns.count).forEach { j -> Void in
            //let center = pointCenter(at: i, of: columns[i].point)
            let point = columns.count > j ? columns[j]?.point : 0.0
            let secondCenter = pointCenter(at: j, of: point ?? 0.0, in: columns)
            line.addLine(to: secondCenter)
        }
        drawLinesUnderPoints(on: line)
        return line.cgPath
    }
    
    func drawLine(startedAt position: Int, with value: CGFloat, from oldValue: CGFloat? = nil) {
        if position < columns.count - 1 {
            let makeLine: (CGPoint, CGPoint) -> CGPath = {
                (center: CGPoint, secondCenter: CGPoint) -> CGPath in
                
                let line = UIBezierPath()
                line.move(to: center)
                line.addLine(to: secondCenter)
                return line.cgPath
            }
            
            let i2 = position + 1
            
            let startPath: CGPath
            if let old = oldValue {
                startPath = makeLine(
                    pointCenter(at: position, of: old, in: columns),
                    pointCenter(at: i2, of: oldColumns[i2]?.point ?? 0.0, in: columns)
                )
            } else {
                startPath = makeLine(
                    pointCenter(at: position, of: 0, in: columns),
                    pointCenter(at: i2, of: 0, in: columns)
                )
            }
            
            let endPath = makeLine(
                pointCenter(at: position, of: value, in: columns),
                pointCenter(at: i2, of: columns[i2].point, in: columns)
            )
            
            let shape = CAShapeLayer()
            layer.addSublayer(shape)
            
            shape.strokeColor = HCColors.colorPrimary.cgColor
            shape.lineWidth = pointRadius / 2
            shape.lineCap = kCALineCapSquare
            
            if needsAnimating {
                shape.path = startPath
                
                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.75
                animation.fromValue = startPath
                animation.toValue = endPath
                
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fillMode = kCAFillModeBoth
                animation.isRemovedOnCompletion = false
                
                shape.add(animation, forKey: animation.keyPath)
            } else {
                shape.path = endPath
            }
        }
    }
}

// Points Draw Extension
extension HistogramChartView {
    
    func drawLinesUnderPoints(on line: UIBezierPath) {
        if columns.count == 0 { return }
        let firstPointCenter = pointCenter(
            at: 0,
            of: columns.first!.point,
            in: columns
        )
        let lastPointCenter = pointCenter(
            at: columns.count - 1,
            of: columns.last!.point,
            in: columns
        )
        let lastBottomPoint = pointCenter(at: columns.count - 1, of: 0, in: columns)
        let firstBottomPoint = pointCenter(at: 0, of: 0, in: columns)
        
        
        line.addQuadCurve(to: lastBottomPoint, controlPoint: lastPointCenter)
        line.addQuadCurve(to: firstBottomPoint, controlPoint: lastBottomPoint)
        line.addQuadCurve(to: firstPointCenter, controlPoint: firstBottomPoint)
    }
}


