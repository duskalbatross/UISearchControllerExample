//
//  SearchControllerForNavigationBarViewController.swift
//  UISearchController
//
//  Created by 吕建廷 on 16/7/2.
//  Copyright © 2016年 吕建廷. All rights reserved.
//

import UIKit

class SearchControllerForNavigationBarViewController: UIViewController {
    var tableView: UITableView!
    
    var searchControllerForNavigationBar: UISearchController!
    
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateDataSource()

        buildUserInterface()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: Private
extension SearchControllerForNavigationBarViewController {
    fileprivate func buildUserInterface() {
        //此示例应用场景类似淘宝首页搜索
        title = "ForNavigationBar"
        
        definesPresentationContext = true
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        buildSearchController(&searchControllerForNavigationBar)
        navigationItem.titleView = searchControllerForNavigationBar.searchBar
    }
    
    fileprivate func buildSearchController(_ searchController: inout UISearchController!){
        let searchResultsVC = SearchResultsController()
        
        searchResultsVC.originalDataSource = dataSource
        
        searchResultsVC.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultsVC)
        
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        searchController.searchBar.keyboardType = .numberPad

        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = true
        
        searchController.searchResultsUpdater = searchResultsVC
        searchController.delegate = self
        searchController.searchBar.delegate = self
    }
    
    fileprivate func generateDataSource() {
        for i in 0 ..< 100 {
            let str = String(i)
            dataSource.append(str)
        }
    }
}

//MARK: UITableViewDataSource
extension SearchControllerForNavigationBarViewController: UITableViewDataSource {
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
        
        cell?.textLabel?.text = dataSource[indexPath.row]
        
        return cell!
    }
}

//MARK: UISearchControllerDelegate
extension SearchControllerForNavigationBarViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
    }
}

//MARK: UISearchBarDelegate
extension SearchControllerForNavigationBarViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //点击键盘上的搜索按钮时执行此代理，可按实际需求进行处理
        print("didClickSearchBuuton")
    }
}

//MARK: SearchResultsControllerDelegate
extension SearchControllerForNavigationBarViewController: SearchResultsControllerDelegate {
    func didClickResult(_ searchResultsController: SearchResultsController, didSelectRowAtIndexPath indexPath: IndexPath) {
        searchControllerForNavigationBar.isActive = false
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) { () -> Void in
            let result = searchResultsController.dataSource[indexPath.row]
            
            let resultDetailVC = ResultDetailViewController()
            
            resultDetailVC.result = result
            
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(resultDetailVC, animated: true)
            self.hidesBottomBarWhenPushed = false
        }
    }
}
