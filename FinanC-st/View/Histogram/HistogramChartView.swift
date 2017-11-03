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
                }
            } else { selectedIndex = nil }
            self.setNeedsDisplay()
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
                    } else if index == i {
                        selectedColumn = nil
                        delegate?.columnDidDeselect()
                    }
                    return
                }
            }
        }
    }
}
