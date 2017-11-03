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
        let columnPath = UIBezierPath(roundedRect: columnRect(at: position, of: column.point), cornerRadius: 2)
        let fillColor: UIColor
        if index == -1 {
            fillColor = HCColors.colorPrimary
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
        
        drawLable(on: context, with: lableRect(at: position), and: column.lable)
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
        
        let pointerLableRect = CGRect()
        drawLable(on: context, with: pointerLableRect, and: "")
    }
}
