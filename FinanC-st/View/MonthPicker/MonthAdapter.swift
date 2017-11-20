//
//  MonthAdapter.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 17.11.2017
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "month"

class MonthAdapter: NSObject {
    
    weak var delegate: MonthAdapterDelegate? = nil
    weak var collectionView: UICollectionView? = nil
    
    var objects: [Model] = []
    
    var selectedIndex: Int {
        return selectedMonth == nil ? -1 : selectedMonth!
    }
    var selectedMonth: Int? = nil {
        didSet {
            if let selected = selectedMonth {
                let indexPath = IndexPath(row: selected, section: 0)
                
                self.delegate?.monthDidSelect(at: indexPath.row, with: objects[indexPath.row])
                self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
            } else {
                self.delegate?.monthDidDeselect()
            }
        }
    }
    
    var dateFrom: DateComponents = DateComponents.initWithNil()
    var dateTo: DateComponents = DateComponents.initWithNil()
    
    func updateObjects() {
//        guard dateFrom.date! >= dateTo.date! else {
//            fatalError("dateFrom must be lower than dateTo")
//        }
        let monthFrom = dateFrom.month!
        let yearFrom = dateFrom.year!
        let valueFrom = monthFrom + yearFrom * 12
        
        let monthTo = dateTo.month!
        let yearTo = dateTo.year!
        let valueTo = monthTo + yearTo * 12
        
        objects = []
        for i in 2..<(valueTo - valueFrom) + 2 {
            let date = dateFrom.calendar!.date(byAdding: .month, value: i, to: dateFrom.date!)!
            
            let month = Calendar.current.component(.month, from: date)
            let year = Calendar.current.component(.year, from: date)
            
            let model = Model(
                date: date,
                title: "\(months[month-1]), \(year)"
            )
            objects.append(model)
        }
        delegate?.updateMonthAdapter()
    }
}

fileprivate let months: [String] = [
    "January", "February",
    "March", "April", "May",
    "June", "July", "August",
    "September", "October", "November",
    "December"
]

extension MonthAdapter: UICollectionViewDataSource {
    
    var overCellsCount: Int {
        let cellSize: CGFloat
        if let collectionView = self.collectionView {
            cellSize = max(collectionView.bounds.width,collectionView.bounds.height)
        } else {
            cellSize = CGFloat(cellWidth * 5)
        }
        
        return Int(cellSize / cellWidth) + 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count + overCellsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MonthCell
        if indexPath.row < self.objects.count {
            cell.monthLabel.text = objects[indexPath.row].title
        } else {
            cell.monthLabel.text = ""
        }
        
//      // MARK: debug cells
//        cell.monthLabel.text = "\(indexPath.row)"
//        if indexPath.row % 2 == 0 {
//            cell.backgroundColor = UIColor.gray
//        } else {
//            cell.backgroundColor = UIColor.white
//        }
        return cell
    }
}

extension MonthAdapter: UICollectionViewDelegate {
    
    var cellWidth: CGFloat {
        get { return 175 }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < self.objects.count {
            selectedMonth = selectedIndex == indexPath.row ? nil : indexPath.row
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
        }
        var indexPath = IndexPath(
            row: (Int(scrollView.contentOffset.x / cellWidth + factor)),
            section: 0
        )
        if indexPath.row < 0 {
            collectionView?.deselectItem(at: IndexPath(row: 0, section: 0), animated: true)
            selectedMonth = 0
            return
        } else if indexPath.row > self.objects.count - 1 {
            let row = self.objects.count - 1
            collectionView?.deselectItem(at: IndexPath(row: row, section: 0), animated: true)
            selectedMonth = row
            return
        }
        
        selectedMonth = indexPath.row
    }
    
}

class Model {
    init() {
        self.date = Date()
        self.title = ""
    }
    init(date: Date, title: String) {
        self.date = date
        self.title = title
    }
    var date: Date
    var title: String
    
    func toString() -> String {
        return "\(title): \(date)"
    }
}

protocol MonthAdapterDelegate: NSObjectProtocol {
    func monthDidSelect(at row: Int, with model: Model)
    func monthDidDeselect()
    func updateMonthAdapter()
}

fileprivate let days_1: [Int64] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
fileprivate let days_2: [Int64] = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

public extension DateComponents {
    
    public static func initWith(year: Int, month: Int, day: Int = 0) -> DateComponents {
        return DateComponents(
            calendar: Calendar.current,
            timeZone: TimeZone.current,
            era: nil,
            year: year,
            month: month,
            day: day,
            hour: nil,
            minute: nil,
            second: nil,
            nanosecond: nil,
            weekday: nil,
            weekdayOrdinal: nil,
            quarter: nil,
            weekOfMonth: nil,
            weekOfYear: nil,
            yearForWeekOfYear: nil
        )
    }
    
    public var monthName: String? {
        if let m = self.month {
            return months[m - 1]
        }
        return nil
    }
    
    public var value: Int64 {
        let year = self.year ?? 0
        let month = self.month ?? 0
        let day = self.day ?? -1
        
        if year == 0 || month == 0 || day == -1 {
            return 0
        }
        let isV = year % 100 != 0 && year % 4 == 0
        let years = isV ? Int64((year - 2016) * 366) : Int64((year - 2016) * 355)
        
        let monthsArray = isV ? days_2 : days_1
        var months: Int64 = 0
        (0..<month).forEach { i in
            months += monthsArray[i]
        }
        
        return years + months
    }
    
    public static func initWithDate(date: Date) -> DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: date)
    }
    
    public static var now: DateComponents {
        return Calendar.current.dateComponents(in: TimeZone.current, from: Date())
    }
    
    public static func initWithNil() -> DateComponents {
        return DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, era: nil, year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil
        )
    }
    
}

