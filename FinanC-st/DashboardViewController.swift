//
//  DashboardViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    let gray = #colorLiteral(red: 0.8078431373, green: 0.831372549, blue: 0.8549019608, alpha: 1)
    
    var selectedWallet: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            self.collectionView.scrollToItem(at: selectedWallet, at: .left, animated: true)
        }
    }
    
    var isExpensesClicker = true
    @IBAction func onExpendsClick(_ sender: UIButton) {
        if !isExpensesClicker {
            isExpensesClicker = true
            incomeButton.backgroundColor = UIColor.white
            incomeButton.setTitleColor(gray, for: .normal)
            
            expensesButton.backgroundColor = gray
            expensesButton.setTitleColor(UIColor.white, for: .normal)
            
            chart.updateColumns(with: expense)
        }
    }
    @IBAction func onIncomeClick(_ sender: UIButton) {
        if isExpensesClicker {
            isExpensesClicker = false
            
            expensesButton.backgroundColor = UIColor.white
            expensesButton.setTitleColor(gray, for: .normal)
            
            incomeButton.setTitleColor(UIColor.white, for: .normal)
            incomeButton.backgroundColor = gray
            
            chart.updateColumns(with: income)
        }
    }
    
    @IBOutlet weak var chart: HistogramChartView!
    
    let wallets: [Wallet] = [
        Wallet("WALLET 1", summ: 300_000, income: 500_000, expense: 200_000),
        Wallet("WALLET 2", summ: -45_000, income: 55_000, expense: -100_000),
        Wallet("WALLET 3", summ: 300_000, income: 500_000, expense: 200_000),
        Wallet("WALLET 4", summ: -45_000, income: 55_000, expense: -100_000),
        Wallet("WALLET 5", summ: 300_000, income: 500_000, expense: 200_000),
        Wallet("WALLET 6", summ: -45_000, income: 55_000, expense: -100_000)
    ]
    let expense: [HistogramColumn] = [
        HistogramColumn(point: 200_000, lable: "JUN"),
        HistogramColumn(point: 275_000, lable: "JUL"),
        HistogramColumn(point: 150_000, lable: "AUG"),
        HistogramColumn(point: 500_000, lable: "SEP"),
        HistogramColumn(point: 160_000, lable: "OKT"),
        HistogramColumn(point: 380_000, lable: "NOV"),
        HistogramColumn(point: 450_000, lable: "DEC")
    ]
    let income: [HistogramColumn] = [
        HistogramColumn(point: 500_000, lable: "JUN"),
        HistogramColumn(point: 150_000, lable: "JUL"),
        HistogramColumn(point: 200_000, lable: "AUG"),
        HistogramColumn(point: 250_000, lable: "SEP"),
        HistogramColumn(point: 125_000, lable: "OKT"),
        HistogramColumn(point: 225_000, lable: "NOV"),
        HistogramColumn(point: 500_000, lable: "DEC")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCornerRadius(to: expensesButton)
        setCornerRadius(to: incomeButton)
        
        let nib = UINib(nibName: "CardCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "wallet")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        chart.chartType = .withColumns
        chart.columns = expense
        chart.delegate = self
//        chart.isDeselectable = false
        
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
    
    func setCornerRadius(to view: UIView) {
        view.clipsToBounds = false
        view.layer.cornerRadius = view.bounds.height / 2
    }
    
    var cellWidth: CGFloat {
        get {
            return self.collectionView.visibleCells.first?.bounds.width ?? 1
        }
    }
//    weak var prevSelectedCell: WalletViewCell? = nil
}

extension DashboardViewController: UIHistogramChartViewDelegate {    
    
    func columnDidSelect(at position: Int, with column: HistogramColumn) {
        
    }
    
    func columnDidDeselect(at position: Int?) {
        
    }
    
}

extension DashboardViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallet", for: indexPath) as! WalletViewCell
        
        cell.initWith(wallet: wallets[indexPath.row])
        cell.isSelectedWallet = (indexPath == selectedWallet)
        
        return cell
    }
    
    func selectedCell() -> WalletViewCell {
        return self.collectionView.cellForItem(at: selectedWallet) as! WalletViewCell
    }
}


extension DashboardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? WalletViewCell
        cell?.isSelectedWallet = true
        selectedWallet = indexPath
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? WalletViewCell
        cell?.isSelectedWallet = false
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = scrollView.contentOffset
        var factor: CGFloat = 0.5
        if velocity.x < 0 {
            factor = -factor
        }
        var indexPath = IndexPath(
            row: (Int(scrollView.contentOffset.x/cellWidth + factor)),
            section: 0
        )
        if indexPath.row != selectedWallet.row {
            if indexPath.row > selectedWallet.row {
                indexPath.row = selectedWallet.row + 1
            } else {
                indexPath.row = selectedWallet.row - 1
            }
        }
        self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
        
        self.collectionView(self.collectionView, didDeselectItemAt: selectedWallet)
        self.collectionView(self.collectionView, didSelectItemAt: indexPath)
    }
    
}

