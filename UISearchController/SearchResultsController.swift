//
//  SearchResultsController.swift
//  UISearchController
//
//  Created by 吕建廷 on 16/7/2.
//  Copyright © 2016年 吕建廷. All rights reserved.
//

import UIKit

protocol SearchResultsControllerDelegate: class {
    func didClickResult(_ searchResultsController: SearchResultsController, didSelectRowAtIndexPath indexPath: IndexPath)
}

class SearchResultsController: UIViewController {

    var tableView: UITableView!
    
    var searchController: UISearchController!
    
    var originalDataSource: [String]! {
        didSet {
            dataSource = originalDataSource
        }
    }
    
    var dataSource: [String]!
    
    var fixedTableViewOriginY: CGFloat = 0
    
    weak var delegate: SearchResultsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Private
extension SearchResultsController {
    fileprivate func buildUserInterface() {
        tableView = UITableView(frame: CGRect(x: 0, y: fixedTableViewOriginY, width: view.bounds.width, height: view.bounds.height), style: .plain)
        view.addSubview(tableView)
        
        tableView.backgroundColor = UIColor.lightGray
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func searchKeywords(_ keywords: String) {
        dataSource.removeAll()
        for str in originalDataSource {
            guard let _ = str.range(of: keywords) else {
                continue
            }
            dataSource.append(str)
        }
        tableView.reloadData()
    }
}

//MARK: UITableViewDataSource
extension SearchResultsController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell?.backgroundColor = UIColor.clear
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        
        return cell!
    }
}

extension SearchResultsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didClickResult(self, didSelectRowAtIndexPath: indexPath)
    }
}

//MARK: UISearchResultsUpdating
extension SearchResultsController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if self.searchController == nil {
            self.searchController = searchController
        }
        guard searchController.searchBar.text ?? "" != "" else {
            return
        }
        searchKeywords(searchController.searchBar.text!)
    }
}

extension SearchResultsController {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}
