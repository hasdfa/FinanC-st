//
//  HistogramChartView+Draw.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

extension HistogramChartView {
    
    func drawColumn(on context: CGContext, with column: HistogramColumn, at position: Int) {
        let columnBaseRect = columnRect(at: position, of: column.point)
        _ = CGRect(
            x: columnBaseRect.minX,
            y: columnBaseRect.maxY,
            width: columnBaseRect.width,
            height: 0
        )
        
        let columnPath = UIBezierPath(roundedRect: columnBaseRect, cornerRadius: 2)
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
        fillColor.setFill()
        columnPath.fill()
    }
    
     func drawSelectedBackground(on context: CGContext , at position: Int){
        let rect = columnBackgroundRect(at: position)
        let columnPath = UIBezierPath(roundedRect: rect, cornerRadius: 2)
        context.saveGState()
        context.setShadow(
            offset: CGSize(width: 0, height: 0),
            blur: 3,
            color: UIColor.black.withAlphaComponent(0.33).cgColor
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
            .font: UIFont.boldSystemFont(ofSize: fontSize),
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

// Points Draw Extension
extension HistogramChartView {
    
    func drawLinesUnderPoints(on line: UIBezierPath) {
        if columns.count == 0 { return }
        let firstPointCenter = pointCenter(
            at: 0,
            of: columns.first!.point
        )
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
        drawLine(
            on: line,
            from: firstBottomPoint,
            to: firstPointCenter,
            with: HCColors.colorPrimaryLight
        )
    }
}


