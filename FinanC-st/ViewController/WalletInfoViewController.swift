//
//  WalletInfoViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 18.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    var wallet: Wallet! {
        didSet {
            wallet.updateHandler = { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
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
        
        initWith(wallet: wallet)
        
        monthAdapter.dateFrom = DateComponents.initWith(year: 2017, month: 4)
        
        let get: (Calendar.Component) -> Int = { component in
            return Calendar.current.component(component, from: Date())
        }
        monthAdapter.dateTo = DateComponents.initWith(
            year: get(.year),
            month: get(.month)
        )
        
        self.flowLayout.itemSize = CGSize(width: 175, height: 21)
        self.monthCollectionView.dataSource = monthAdapter
        self.monthCollectionView.delegate = monthAdapter
        
        monthAdapter.delegate = self
        self.monthAdapter.updateObjects()
        self.monthDidDeselect()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func initWith(wallet: Wallet) {
        walletTitle.text = wallet.name
        averageSumm.text = "$\(Int(wallet.averageSumm))"
        
        expenseLabel.text = "$\(Int(wallet.expense))"
        incomeLabel.text = "$\(Int(wallet.income))"
        
        cardBackground.backgroundColor = WalletBlueScheme.backgroundColor
        cardBackground.clipsToBounds = false
        cardBackground.layer.cornerRadius = 8
    }
}

extension WalletInfoViewController: MonthAdapterDelegate {
    
    func updateMonthAdapter() {
        self.monthCollectionView.reloadData()
    }
    
    func monthDidSelect(at row: Int, with model: Model) {
        self.wallet.selectedMonth = Calendar.current.component(.month, from: model.date)
        UIView.animate(withDuration: 0.5) {
            self.indicatorView.alpha = 1
        }
    }
    
    func monthDidDeselect() {
        self.wallet.selectedMonth = nil
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
        header.textLabel?.font = UIFont.withMontesrrat(ofSize: 12, ofType: .bold)
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
    case custom = "nil"
    case null = "Nothing"
    
    var title: String {
        return self.rawValue
    }
    
    var image: UIImage? {
        switch self {
            case .rent: return #imageLiteral(resourceName: "rent")
            case .bill: return #imageLiteral(resourceName: "bill")
            case .insurance: return #imageLiteral(resourceName: "insurance")
            case .utilites: return #imageLiteral(resourceName: "utilites")
            case .electronics: return #imageLiteral(resourceName: "electronics")
            case .clothing: return #imageLiteral(resourceName: "clothing")
            case .gadgets: return #imageLiteral(resourceName: "gadget")
            case .savings: return #imageLiteral(resourceName: "savings")
            case .custom: return nil
            case .null: return nil
        }
    }
}

