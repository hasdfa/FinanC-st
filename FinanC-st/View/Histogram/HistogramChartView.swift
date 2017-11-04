//
//  HistogramChartView.swift
//  Charts
//
//  Created by Raksha Vadim on 03.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class HistogramChartView: UIView {
    
    public var isSelectable = true {
        didSet {
            if oldValue != isSelectable {
                if isSelectable {
                    initTapGesture()
                } else {
                    if tapGestureRecognizer != nil {
                        self.removeGestureRecognizer(tapGestureRecognizer!)
                        tapGestureRecognizer = nil
                    }
                }
            }
        }
    }
    public weak var delegate: UIHistogramChartViewDelegate? = nil
    
    var index: Int = -1
    public var selectedColumn: Int? {
        set {
            if let val = newValue,
                val >= 0 || val < columns.count{
                if index != val {
                    index = val
                }
            } else {
                if index != -1 {
                    delegate?.columnDidDeselect()
                }
                index = -1
            }
            self.setNeedsDisplay()
        }
        get { return index == -1 ? nil : index }
    }
    public func deselectColumn() {
        selectedColumn = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initTapGesture()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTapGesture()
    }
    
    public var columns: [HistogramColumn] = [] {
        didSet {
            self.setNeedsDisplay()
        }
    }
    init(with columns: [HistogramColumn]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.columns = columns
        initTapGesture()
    }
    
    private var tapGestureRecognizer: UITapGestureRecognizer? = nil
    func initTapGesture() {
        tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleEvent(_:))
        )
        tapGestureRecognizer?.numberOfTapsRequired = 1
        tapGestureRecognizer?.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapGestureRecognizer!)
    }
    
    var defaultColumnsColor: UIColor = HCColors.colorPrimary
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        var i = 0
        columns.forEach { it -> Void in
            defer { i += 1 }
            drawColumn(on: context, with: it, at: i)
            drawLabel(on: context, at: i, and: it.lable)
        }
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
                    }
                }
            }
            // Unfocus by tap outside
            selectedColumn = nil
        }
    }
    
    
    deinit {
        if tapGestureRecognizer != nil {
            self.removeGestureRecognizer(tapGestureRecognizer!)
        }
        if delegate != nil {
            delegate = nil
        }
    }
}
