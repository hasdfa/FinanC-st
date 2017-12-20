//
//  DashboardViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 11.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit
import CoreData

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
    
    @IBAction func addWalletAction(_ sender: Any) {
        if let addWalletVC = storyboard?.instantiateViewController(withIdentifier: "add-wallet") {
            self.present(addWalletVC, animated: true, completion: nil)
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
            
            let wallet = walletAdapter.selectedWallet
            chart.updateColumns(from: wallet.incomes, to: wallet.expenses)
        }
    }
    @IBAction func onIncomeClick(_ sender: UIButton) {
        if isExpensesClicker {
            isExpensesClicker = false
            
            expensesButton.backgroundColor = UIColor.white
            expensesButton.setTitleColor(gray, for: .normal)
            
            incomeButton.setTitleColor(UIColor.white, for: .normal)
            incomeButton.backgroundColor = gray
            
            let wallet = walletAdapter.selectedWallet
            chart.updateColumns(from: wallet.expenses, to: wallet.incomes)
        }
    }
    
    @IBOutlet weak var chart: HistogramChartView!
    
    var wallets: [Wallet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        expensesButton.setCornerRadius()
        incomeButton.setCornerRadius()
        
        walletAdapter.delegate = self
        
        chart.chartType = .withColumns
        chart.delegate = self
        
        monthAdapter.delegate = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        self.indicatorView.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let fetchRequest: NSFetchRequest<Wallet> = Wallet.fetchRequest()
        wallets = try! viewContext.fetch(fetchRequest)
        
        if wallets.count > 0 {
            walletAdapter.wallets = self.wallets
            collectionView.dataSource = walletAdapter
            collectionView.delegate = walletAdapter
            
            chart.columns = walletAdapter.selectedWallet.expenses
            
            self.flowLayout.itemSize = CGSize(width: 175, height: 21)
            
            self.monthAdapter.dates = wallets.first!.dates
            
            self.monthCollectionView.dataSource = monthAdapter
            self.monthCollectionView.delegate = monthAdapter
            self.monthDidDeselect()
            
            let indexPath = IndexPath(row: 0, section: 0)
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .left)
            
            chart.setNeedsAnimating()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if wallets.count < 1 {
            addWalletAction(self)
        }
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
        if self.chart.selectedColumn != nil
            && !wallet.dates.contains(
                monthAdapter.objects[self.chart.selectedColumn!].date
            ) {
            self.monthAdapter.selectedMonth = nil
            wallet.selectedMonth = nil
        }
        
        self.chart.columns = isExpensesClicker ? wallet.expenses : wallet.incomes
        self.monthAdapter.dates = wallet.dates
    }
    
    func walletWillOpen(at postion: Int, with wallet: Wallet) {
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
    
    func monthDidSelect(at row: Int, with model: MonthModel) {
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
