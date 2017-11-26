//
//  DashboardViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            if collectionView != nil {
                walletAdapter.collectionView = collectionView
            }
        }
    }
    @IBOutlet weak var monthCollectionView: UICollectionView! {
        didSet {
            if monthCollectionView != nil {
                monthAdapter.collectionView = monthCollectionView
            }
        }
    }
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var monthAdapter: MonthAdapter = MonthAdapter()
    var walletAdapter: WalletAdapter = WalletAdapter([])
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var incomeButton: UIButton!
    let gray = #colorLiteral(red: 0.8078431373, green: 0.831372549, blue: 0.8549019608, alpha: 1)
    
    @IBAction func openDrawer(_ sender: UIButton) {
        sender.tintColor = UIColor.black
        if !(self.drawerViewController?.isOpen ?? false) {
            self.drawerViewController?.open()
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
//        Wallet("WALLET 1", summ: 300_000, income: 500_000, expense: 200_000),
//        Wallet("WALLET 2", summ: -45_000, income: 55_000, expense: -100_000),
//        Wallet("WALLET 3", summ: 300_000, income: 500_000, expense: 200_000),
//        Wallet("WALLET 4", summ: -45_000, income: 55_000, expense: -100_000),
//        Wallet("WALLET 5", summ: 300_000, income: 500_000, expense: 200_000),
//        Wallet("WALLET 6", summ: -45_000, income: 55_000, expense: -100_000)
    ]
    let expense: [HistogramColumn] = [
        HistogramColumn(point: 500_000, lable: "MAY"),
        HistogramColumn(point: 200_000, lable: "JUN"),
        HistogramColumn(point: 275_000, lable: "JUL"),
        HistogramColumn(point: 150_000, lable: "AUG"),
        HistogramColumn(point: 500_000, lable: "SEP"),
        HistogramColumn(point: 160_000, lable: "OKT"),
        HistogramColumn(point: 380_000, lable: "NOV"),
    ]
    let income: [HistogramColumn] = [
        HistogramColumn(point: 250_000, lable: "MAY"),
        HistogramColumn(point: 500_000, lable: "JUN"),
        HistogramColumn(point: 150_000, lable: "JUL"),
        HistogramColumn(point: 200_000, lable: "AUG"),
        HistogramColumn(point: 250_000, lable: "SEP"),
        HistogramColumn(point: 125_000, lable: "OKT"),
        HistogramColumn(point: 225_000, lable: "NOV"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        expensesButton.setCornerRadius()
        incomeButton.setCornerRadius()
        
        walletAdapter.delegate = self
        walletAdapter.wallets = self.wallets
        collectionView.dataSource = walletAdapter
        collectionView.delegate = walletAdapter
        
        chart.chartType = .withColumns
        chart.columns = expense
        chart.delegate = self
//        chart.isDeselectable = false
        
        monthAdapter.dateFrom = DateComponents.initWith(year: 2017, month: 4)
        
        let get: (Calendar.Component) -> Int = { component in
            return Calendar.current.component(component, from: Date())
        }
        monthAdapter.dateTo = DateComponents.initWith(
            year: get(.year),
            month: get(.month),
            day: get(.day)
        )
        
        self.flowLayout.itemSize = CGSize(width: 175, height: 21)
        
        self.monthCollectionView.dataSource = monthAdapter
        self.monthCollectionView.delegate = monthAdapter
        monthAdapter.delegate = self
        self.monthAdapter.updateObjects()
        self.monthDidDeselect()
        
        let indexPath = IndexPath(row: 0, section: 0)
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
    }
}

extension UIView {
    func setCornerRadius() {
        self.clipsToBounds = false
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

extension DashboardViewController: UIHistogramChartViewDelegate {    
    
    func columnDidSelect(at position: Int, with column: HistogramColumn) {
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 1
        }
        self.monthCollectionView.selectItem(at: IndexPath(row: position, section: 0), animated: true, scrollPosition: .left)
    }
    
    func columnDidDeselect(at position: Int?) {
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 0
        }
    }
    
    
    
}

extension DashboardViewController: WalletAdapterDelegate {
    
    func walletDidSelect(at postion: Int, with wallet: Wallet) {
        
    }
    
    func walletWillOpen(at postion: Int, with wallet: Wallet) {
        wallet.transactions = [
//            Transaction(description: "Some1", icon: .rent, type: .expenses, value: 100.05),
//            Transaction(description: "Some2", icon: .clothing, type: .expenses,
//                        value: 5000.50,
//                        date: DateComponents.initWith(year: 2017, month: 5, day: 6)),
//            Transaction(description: "Some3", icon: .bill, type: .expenses, value: 45.00),
//            Transaction(description: "Some4", icon: .gadgets, type: .expenses,
//                        value: 60_000.00,
//                        date: DateComponents.initWith(year: 2017, month: 7, day: 6)),
//            Transaction(description: "Some5", icon: .electronics, type: .expenses,
//                        value: 100.00,
//                        date: DateComponents.initWith(year: 2017, month: 5, day: 6)),
//            Transaction(description: "Some6", icon: .insurance, type: .expenses,
//                        value: 2_500.00,
//                        date: DateComponents.initWith(year: 2017, month: 7, day: 6))
        ]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "wallet") as? WalletInfoViewController {
            vc.wallet = wallet
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func updateWalletAdapter() {
        self.collectionView.reloadData()
    }
}

extension DashboardViewController: MonthAdapterDelegate {
    
    func updateMonthAdapter() {
        self.monthCollectionView.reloadData()
    }
    
    func monthDidSelect(at row: Int, with model: Model) {
        self.chart.selectedColumn = row
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 1
        }
    }
    
    func monthDidDeselect() {
        self.chart.deselectColumn()
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 0
        }
    }
}
