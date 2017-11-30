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
    
    var objects: [MonthModel] = []
    
    var selectedIndex: Int {
        return selectedMonth == nil ? -1 : selectedMonth!
    }
    var selectedMonth: Int? = nil {
        didSet {
            if let selected = selectedMonth {
                let indexPath = IndexPath(row: selected, section: 0)
                
                if indexPath.row < 0 || indexPath.row >= objects.count {
                    return
                }
                self.delegate?.monthDidSelect(at: indexPath.row, with: objects[indexPath.row])
                self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
            } else {
                self.delegate?.monthDidDeselect()
            }
        }
    }
    var selectedDate: DateComponents? {
        return selectedIndex == -1 ? nil : dates[selectedIndex]
    }
    
    var dates: [DateComponents] = [] {
        didSet {
            objects = dates.map {
                MonthModel(
                    date: $0.date!,
                    title: "\( $0.monthName!), \($0.year!)"
                )
            }
            delegate?.updateMonthAdapter()
        }
    }
    
//    func updateObjects() {
//        guard dateFrom.date! >= dateTo.date! else {
//            fatalError("dateFrom must be lower than dateTo")
//        }
//        let monthFrom = dateFrom.month!
//        let yearFrom = dateFrom.year!
//        let valueFrom = monthFrom + yearFrom * 12
//
//        let monthTo = dateTo.month!
//        let yearTo = dateTo.year!
//        let valueTo = monthTo + yearTo * 12
//
//        objects = []
//        for i in 2..<(valueTo - valueFrom) + 2 {
//            let date = dateFrom.calendar!.date(byAdding: .month, value: i, to: dateFrom.date!)!
//
//            let month = Calendar.current.component(.month, from: date)
//            let year = Calendar.current.component(.year, from: date)
//
//            let model = MonthModel(
//                date: date,
//                title: "\(DateComponents.monthName(for: month -  1)), \(year)"
//            )
//            objects.append(model)
//        }
//        delegate?.updateMonthAdapter()
//    }
}

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
        
        // MARK: debug cells
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

protocol MonthAdapterDelegate: NSObjectProtocol {
    func monthDidSelect(at row: Int, with model: MonthModel)
    func monthDidDeselect()
    func updateMonthAdapter()
}
