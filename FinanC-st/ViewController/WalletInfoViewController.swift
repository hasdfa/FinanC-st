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
        
        update()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
        averageSumm.text = "$\(wallet.allMoney.toString())"
        
        expenseLabel.text = "$" + Double(wallet.expensesAtAllTime).toString()
        incomeLabel.text = "$" + Double(wallet.incomesAtAllTime).toString()
        
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
        expenseLabel.text = "$" + Double(wallet.expense(on: date).point).toString()
        incomeLabel.text = "$" + Double(wallet.income(on: date).point).toString()
        
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 1
        }
    }
    
    func monthDidDeselect() {
        self.wallet.selectedMonth = nil
        self.tableView.reloadData()
        
        expenseLabel.text = "$" + Double(wallet.expensesAtAllTime).toString()
        incomeLabel.text = "$" + Double(wallet.incomesAtAllTime).toString()
        
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
            
            cell.initWith(transaction: transaction)
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

enum CategoryType: String {
    case rent = "Rent"
    case bill = "Bill"
    case insurance = "Insurance"
    case utilites = "Utilites"
    case electronics = "Electronics"
    case clothing = "Clothings"
    case gadgets = "Gadgets"
    case savings = "Savings"
    
    var title: String {
        return self.rawValue
    }
    
    static let all: [CategoryType] = [
        .rent,
        .bill,
        .insurance,
        .utilites,
        .electronics,
        .clothing,
        .gadgets,
        .savings
    ]
    
    var image: UIImage {
        switch self {
            case .rent: return #imageLiteral(resourceName: "rent")
            case .bill: return #imageLiteral(resourceName: "bill")
            case .insurance: return #imageLiteral(resourceName: "insurance")
            case .utilites: return #imageLiteral(resourceName: "utilites")
            case .electronics: return #imageLiteral(resourceName: "electronics")
            case .clothing: return #imageLiteral(resourceName: "clothing")
            case .gadgets: return #imageLiteral(resourceName: "gadget")
            case .savings: return #imageLiteral(resourceName: "savings")
        }
    }
}

