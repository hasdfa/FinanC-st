//
//  HistogramChartView.swift
//  Charts
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class HistogramChartView: UIView {
    
    public var chartType: HistogramChartType = .withColumns
    public var columns: [HistogramColumn] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    public var oldColumns: [HistogramColumn?] = []
    
    public func updateColumns(with columns: [HistogramColumn]) {
        if columns.count != self.columns.count { fatalError("updateColumns(with:) Columns count must be the same!") }
        needsAnimating = true
        oldColumns = self.columns
        self.columns = columns
    }
    
    public func updateColumns(from oldColumns: [HistogramColumn], to columns: [HistogramColumn]) {
        if columns.count != oldColumns.count { fatalError("updateColumns(with:) Columns count must be the same!") }
        needsAnimating = true
        self.oldColumns = oldColumns
        self.columns = columns
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        var i = 0
        switch chartType {
            case .withPoint, .withColumnsAndPoints:
                isSelectable = false
                defaultColumnsColor = HCColors.colorPrimaryLight
            default: break
        }
        
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        let drawIn: (HistogramColumn) -> Void
        switch chartType {
        case .withColumns:
            drawIn = { it -> Void in
                let old = self.oldColumns.count == 0 ? nil : self.oldColumns[i]
                self.drawColumn(on: context, with: it, at: i, from: old)
            }
        case .withColumnsAndPoints:
            columns.forEach { it -> Void in
                defer { i += 1 }
                let old = oldColumns.count == 0 ? nil : self.oldColumns[i]
                self.drawColumn(on: context, with: it, at: i, from: old)
            }
            i = 0
            drawIn = { it -> Void in
                let old = self.oldColumns.count == 0 ? nil : self.oldColumns[i]
                self.drawLine(startedAt: i, with: it.point, from: old?.point)
                self.drawPoints(at: i, with: it.point, from: old?.point)
            }
        case .withPoint:
            var drawLineWith: ([HistogramColumn?]) -> CGPath = { clmns in
                return self.drawLinesPlace(columns: clmns)
            }
            let shape = CAShapeLayer()
            self.layer.addSublayer(shape)
            
            shape.fillColor = HCColors.colorPrimaryLight.cgColor
            
            let startPath = drawLineWith(self.oldColumns)
            let endPath = drawLineWith(self.columns)
            
            if needsAnimating {
                shape.path = startPath

                let animation = CABasicAnimation(keyPath: "path")
                animation.duration = 0.75
                animation.fromValue = startPath
                animation.toValue = endPath
                
                // TODO: узнать что это
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                animation.fillMode = kCAFillModeBoth
                animation.isRemovedOnCompletion = false
                
                shape.add(animation, forKey: animation.keyPath)
            } else {
                shape.path = endPath
            }
            
            
            drawIn = { it -> Void in
                let old = self.oldColumns.count == 0 ? nil : self.oldColumns[i]

                self.drawLine(startedAt: i, with: it.point, from: old?.point)
                self.drawPoints(at: i, with: it.point, from: old?.point)
            }
        }
        
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawIn(it)
            drawLabel(on: context, at: i, and: it.lable)
        }
        
        needsAnimating = false
        oldColumns = []
    }
    
    public weak var delegate: UIHistogramChartViewDelegate? = nil
    private var tapGestureRecognizer: UITapGestureRecognizer? = nil
    var defaultColumnsColor: UIColor = HCColors.colorPrimary
    var index: Int = -1
    public var isSelectable = true {
        didSet {
            handleSelectableChange(with: oldValue)
            needsAnimating = true
        }
    }
    public var isDeselectable = true {
        didSet {
            if !isDeselectable {
                selectedColumn = 0
            }
        }
    }
    public var needsAnimating = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        onInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInit()
    }
    init(with columns: [HistogramColumn]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.columns = columns
        onInit()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if let gesture = tapGestureRecognizer {
            self.removeGestureRecognizer(gesture)
        }
        if delegate != nil {
            delegate = nil
        }
    }
}



extension HistogramChartView {
    public var selectedColumn: Int? {
        set {
            if let val = newValue,
                val >= 0 || val < columns.count{
                if index != val {
                    index = val
                }
            } else {
                index = -1
            }
            self.setNeedsDisplay()
        }
        get { return index == -1 ? nil : index }
    }
    public func deselectColumn() {
        selectedColumn = nil
    }
}

extension HistogramChartView {
    
    fileprivate func observeRotationChange() {
        NotificationCenter.default.addObserver(self,
            selector: #selector(handleOrientationChange(_:)),
            name: .UIApplicationWillChangeStatusBarOrientation,
            object: nil
        )
    }
    
    @objc func handleOrientationChange(_ notification: Notification) {
        needsAnimating = true
    }
    
}

extension HistogramChartView {
    
    func handleSelectableChange(with oldValue: Bool) {
        if oldValue != isSelectable {
            if isSelectable {
                onInit()
            } else {
                if tapGestureRecognizer != nil {
                    self.removeGestureRecognizer(tapGestureRecognizer!)
                    tapGestureRecognizer = nil
                }
            }
        }
    }
    
    func onInit() {
        self.contentMode = .redraw
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleEvent(_:))
        )
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer!)
        observeRotationChange()
    }
    
    @objc
    func handleEvent(_ gesture: UITapGestureRecognizer) {
        if !isSelectable {
            print("Imposible")
        }
        if gesture.state == .recognized {
            let point = gesture.location(in: self)
            let x = point.x
            let y = point.y
            
            var i = 0
            for column in columns {
                defer { i += 1 }
                let frame = columnBackgroundRect(at: i)
                
                // Check if tap is in \(i) column
                if (x >= frame.minX && x <= frame.maxX)
                    && (y >= frame.minY && y <= frame.maxY) {
                    if index != i {
                        selectedColumn = i
                        delegate?.columnDidSelect(at: i, with: column)
                        return
                    } else {
                        if isDeselectable {
                            selectedColumn = nil
                            self.delegate?.columnDidDeselect(at: i)
                        }
                    }
                }
            }
            // Unfocus by tap outside
            if isDeselectable {
                selectedColumn = nil
                self.delegate?.columnDidDeselect(at: nil)
            }
        }
    }
}
