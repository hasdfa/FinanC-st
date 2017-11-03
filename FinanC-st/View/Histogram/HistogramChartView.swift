//
//  HistogramChartView.swift
//  Charts
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class HistogramChartView: UIView {
    
    public weak var delegate: UIHistogramChartViewDelegate? = nil
    
    private var selectedIndex: Int? = nil
    public var selectedColumn: Int? {
        set {
            if let val = newValue,
                val >= 0 || val < columns.count{
                if selectedIndex != val {
                    selectedIndex = val
                    self.setNeedsDisplay()
                }
            } else { selectedIndex = nil }
        }
        get { return selectedIndex }
    }
    var index: Int { get { return selectedIndex ?? -1 } }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTapGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTapGesture()
    }
    
    public var columns: [HistogramColumn] = []
    init(with columns: [HistogramColumn]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.columns = columns
        initTapGesture()
    }
    init(with columns: [HistogramColumn], and frame: CGRect) {
        super.init(frame: frame)
        self.columns = columns
        initTapGesture()
    }
    
    func initTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleEvent(_:))
        )
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        var i = 0
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawColumn(on: context, with: it, at: i)
        }
    }
    
    @objc
    func handleEvent(_ gesture: UITapGestureRecognizer) {
        if gesture.state == .recognized {
            let point = gesture.location(in: self)
            let x = point.x
            let y = point.y
            
            var i = 0
            for column in columns {
                defer { i += 1 }
                let frame = columnBackgroundRect(at: i)
                
                if (x >= frame.minX && x <= frame.maxX)
                    && (y >= frame.minY && y <= frame.maxY) {
                    if index != i {
                        selectedColumn = i
                        delegate?.columnDidSelect(at: i, with: column)
                    } else {
                        delegate?.columnDidDeselect()
                    }
                    return
                }
            }
        }
    }
}

struct HCConst {
    public static let columnWidthPercent: Double = 65
}
struct HCColors {
    public static let white = UIColor.white
    public static let colorPrimary = UIColor(red: 0.471, green: 0.682, blue: 0.976, alpha: 1)
    public static let colorPrimaryLight = UIColor(red: 0.851, green: 0.910, blue: 0.992, alpha: 1)
    public static let colorGraySecondary = UIColor(red: 0.741, green: 0.765, blue: 0.792, alpha: 1)
    public static let colorGrayPrimary = UIColor(red: 0.478, green: 0.494, blue: 0.510, alpha: 1)
}

extension HistogramChartView {
    
    private func drawColumn(on context: CGContext, with column: HistogramColumn, at position: Int) {
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
    
    private func drawSelectedBackground(on context: CGContext , at position: Int){
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
    
    private func drawLable(on context: CGContext, with frame: CGRect, and text: String) {
        //// lable Drawing
        let lableTextContent = text
        let lableStyle = NSMutableParagraphStyle()
        lableStyle.alignment = .center
        let lableFontAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 14),
            .foregroundColor: HCColors.colorGraySecondary,
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
    
    
    // TODO: Add normal coordinates
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
        
        
        //// Label Drawing
        let labelRect = CGRect(x: 108.08, y: 6, width: 20.33, height: 11)
        let labelTextContent = text
        let labelStyle = NSMutableParagraphStyle()
        labelStyle.alignment = .center
        let labelFontAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 12),
            .foregroundColor: HCColors.white,
            .paragraphStyle: labelStyle,
            ] as [NSAttributedStringKey: Any]
        
        let labelTextHeight: CGFloat = labelTextContent.boundingRect(with: CGSize(width: labelRect.width, height: CGFloat.infinity), options: .usesLineFragmentOrigin, attributes: labelFontAttributes, context: nil).height
        context.saveGState()
        context.clip(to: labelRect)
        labelTextContent.draw(in: CGRect(x: labelRect.minX, y: labelRect.minY + (labelRect.height - labelTextHeight) / 2, width: labelRect.width, height: labelTextHeight), withAttributes: labelFontAttributes)
        context.restoreGState()
    }
    
}

