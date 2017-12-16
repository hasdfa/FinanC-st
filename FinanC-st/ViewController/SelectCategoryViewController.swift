//
//  SelectCategoryViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 28.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController {

    public var onSelect: ((CategoryType) -> Void)? = nil

    lazy var selectedCategories: [CategoryType] = {
        return CategoryType.all
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func close(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}

extension SelectCategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var tempSelectedCategories = [CategoryType]()
        defer {
            self.selectedCategories = tempSelectedCategories
            self.tableView.reloadData()
        }
        if searchText.isEmpty {
            tempSelectedCategories = CategoryType.all
            return
        }
        CategoryType.all.forEach { c in
            let title = c.title.lowercased()
            if title.localizedStandardContains(searchText.lowercased()) {
                tempSelectedCategories.append(c)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        selectedCategories = CategoryType.all
        self.tableView.reloadData()
        
        searchBar.text = nil
    }
}

extension SelectCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = selectedCategories[indexPath.row]
        
        cell.textLabel?.font = .montesrrat(ofSize: 15, ofType: .semiBold)
        
        cell.textLabel?.text = category.title
        cell.imageView?.image = category.image
        cell.imageView?.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cell.imageView?.layoutMarginsDidChange()
        
        return cell
    }
    
}

extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(CategoryType.all[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
