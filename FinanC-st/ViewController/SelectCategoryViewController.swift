//
//  SelectCategoryViewController.swift
//  FinanC-st
//
//  Created by Raksha Vadim on 28.11.2017.
//  Copyright © 2017 Raksha Vadim. All rights reserved.
//

import UIKit

class SelectCategoryViewController: UIViewController {

    let categories: [CategoryType] = [
        .rent,
        .bill,
        .insurance,
        .utilites,
        .electronics,
        .clothing,
        .gadgets,
        .savings
    ]
    lazy var selectedCategories = {
        return categories
    }()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
    }
}

extension SelectCategoryViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            let tempSelectedCategories = [CategoryType]()
            categories.forEach { c in
                if c.title.starts(with: text) {
                    self.selectedCategories.append(c)
                }
            }
            self.selectedCategories = tempSelectedCategories
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        selectedCategories = categories
    }
}

extension SelectCategoryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let category = selectedCategories[indexPath.row]
        
        cell.textLabel?.text = category.title
        cell.imageView?.image = category.image
        
        return cell
    }
    
}

extension SelectCategoryViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
