//
//  WalletInfoViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 18.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit
import CoreData

class WalletInfoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cardBackground: UIView!
    @IBOutlet weak var walletTitle: UILabel!
    @IBOutlet weak var averageSumm: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var expenseLabel: UILabel!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var monthCollectionView: UICollectionView! {
        didSet {
            monthAdapter.collectionView = monthCollectionView
        }
    }
    @IBOutlet weak var indicatorView: UIView!
    
    @IBAction func addTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func closeAction(_ sender: Any) {
        wallet.selectedMonth = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editWallet(_ sender: UIButton) {
        let showDeleteAlert = {
            let alert = UIAlertController(title: "Are you shure to delete this wallet?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                if let context = self.wallet.managedObjectContext {
                    context.delete(self.wallet)
                    try! context.save()
                    self.dismiss(animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        let showEditTitleAction = {
            let alert = UIAlertController(title: "Are you shure to delete this wallet?", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: { textField in
                textField.text = self.wallet.title
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                if let title = alert.textFields?.first?.text {
                    self.wallet.title = title
                    try! self.wallet.managedObjectContext?.save()
                    self.update()
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let alertSheet = UIAlertController(title: "Edit wallet", message: nil, preferredStyle: .actionSheet)
        alertSheet.addAction(UIAlertAction(title: "Edit name", style: .default, handler: { _ in
            showEditTitleAction()
        }))
        alertSheet.addAction(UIAlertAction(title: "Delete wallet", style: .default, handler: { _ in
            showDeleteAlert()
        }))
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertSheet, animated: true, completion: nil)
    }
    
    
    
    var wallet: Wallet!
    var monthAdapter: MonthAdapter = MonthAdapter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if wallet == nil {
            self.dismiss(animated: true, completion: {
                // MARK: TODO Alert
                // "Nothing to show"
            })
            return
        }
        
        self.flowLayout.itemSize = CGSize(width: 175, height: 21)
        self.monthCollectionView.dataSource = monthAdapter
        self.monthCollectionView.delegate = monthAdapter
        
        monthAdapter.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        wallet.selectedMonth = nil
        update()
    }
    
    private func update() {
        wallet.update()
        
        initWith(wallet: wallet)
        monthAdapter.dates = wallet.dates
        self.monthDidDeselect()
    }
    
    public func initWith(wallet: Wallet) {
        walletTitle.text = wallet.title
        averageSumm.text = "\(wallet.currencyType.rawValue)\(wallet.allMoney.toString())"
        
        expenseLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.expensesAtAllTime).toString()
        incomeLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.incomesAtAllTime).toString()
        
        cardBackground.backgroundColor = WalletBlueScheme.backgroundColor
        cardBackground.clipsToBounds = false
        cardBackground.layer.cornerRadius = 8
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController {
            if let addTransaction = navigationController.childViewControllers[0] as? AddTransactionViewController {
                addTransaction.wallet = self.wallet
            }
        }
    }
}

extension WalletInfoViewController: MonthAdapterDelegate {
    
    func updateMonthAdapter() {
        self.monthCollectionView.reloadData()
    }
    
    func monthDidSelect(at row: Int, with model: MonthModel) {
        self.wallet.selectedMonth = model.date.month ?? -1
        self.tableView.reloadData()
        
        let date = model.date
        expenseLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.expense(on: date).point).toString()
        incomeLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.income(on: date).point).toString()
        
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 1
        }
    }
    
    func monthDidDeselect() {
        self.wallet.selectedMonth = nil
        self.tableView.reloadData()
        
        expenseLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.expensesAtAllTime).toString()
        incomeLabel.text = "\(wallet.currencyType.rawValue)" + Double(wallet.incomesAtAllTime).toString()
        
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 0
        }
    }
}


extension WalletInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return wallet.dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = wallet.dates[section]
        let count = wallet.transactionGoupedByDate[date.value]?.count ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            let date = wallet.dates[indexPath.section]
            var transactions: [Transaction?] {
                return self.wallet.transactionGoupedByDate[date.value] ?? []
            }
            let transaction = transactions[indexPath.row]
            
            if let transaction = transaction {
                viewContext.delete(transaction)
                try! viewContext.save()
            }
            
            wallet.update()
            
            if transactions.count > 0 {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                tableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
            }

            tableView.endUpdates()
            
            if !wallet.dates.contains(where: { $0.value == date.value }) {
                self.monthAdapter.dates = wallet.dates
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = wallet.dates[section]
        return "\(String(describing: date.day!)) \(date.monthName!) \(String(describing: date.year!))"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "wallet", for: indexPath) as! TransactionCell
        if let trancs = wallet
            .transactionGoupedByDate[wallet.dates[indexPath.section].value] {
            let transaction = trancs[indexPath.row]
            
            cell.initWith(transaction: transaction, currency: wallet.currencyType)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = UIFont.montesrrat(ofSize: 12, ofType: .bold)
//        header.textLabel?.frame = header.frame
        header.textLabel?.textAlignment = .left
    }
}

extension WalletInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
}

