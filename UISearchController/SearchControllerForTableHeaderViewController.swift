//
//  ViewController.swift
//  UISearchController
//
//  Created by 吕建廷 on 16/7/2.
//  Copyright © 2016年 吕建廷. All rights reserved.
//

import UIKit

class SearchControllerForTableHeaderViewController: UIViewController {
    var tableView: UITableView!
    
    var searchControllerForTableHeaderView: UISearchController!
    
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
extension SearchControllerForTableHeaderViewController {
    fileprivate func buildUserInterface() {
        //此示例应用场景类似微信首页搜索
        title = "ForTableHeaderView"
        
        //对searchController放在tableViewHeaderView的情况，definesPresentationContext若设置为true会存在细微的动画bug，但对searchController放在navigationBar的情况，必须将此属性设置为true
        //Warnning: definesPresentationContext = true可能会对同一nav下的其他页面产生影响导致一些诡异bug，建议在viewWillDisappear时强制设置为默认的definesPresentationContext = false
        definesPresentationContext = false

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
        buildSearchController(&searchControllerForTableHeaderView)
        tableView.tableHeaderView = searchControllerForTableHeaderView.searchBar
    }
    
    fileprivate func buildSearchController(_ searchController: inout UISearchController!){
        let searchResultsVC = SearchResultsController()

        searchResultsVC.originalDataSource = dataSource
        
        //修正searchResultsVC.tableView因tabBar产生的误差,疑似UISearchController内部机制造成
        searchResultsVC.fixedTableViewOriginY = -49
        
        searchResultsVC.delegate = self
                
        //若searchResultsUpdater的代理只需设置当前vc即可满足需求，searchResultsController传入nil即可
        searchController = UISearchController(searchResultsController: searchResultsVC)
        
        searchController.searchBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 44)
        searchController.searchBar.keyboardType = .numberPad

        searchController.hidesNavigationBarDuringPresentation = true
        searchController.dimsBackgroundDuringPresentation = true
        
        //更改取消按钮颜色，若直接设置UISearchController.searchBar.tintColor会导致光标颜色改变
        if #available(iOS 9.0, *) {
            //此方法仅对9.0之后版本生效
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        } else {
            //对9.0之前版本需桥接OC版对UIBarButtonItem的扩展
            UIBarButtonItem.my_appearanceWhenContained(in: UISearchBar.self).tintColor = UIColor.white
        }
        
        //Bug: 向searchBar中粘贴字符串或者代码控制直接像searchBar.text赋值，键盘上的搜索按钮依然处于失效状态
        //解决方案A:
        //关闭searBar输入为空时自动将搜索按钮置失效
        searchController.searchBar.enablesReturnKeyAutomatically = false
        
        //解决方案B:在向searchBar中粘贴字符串或者代码控制直接向searchBar.text赋值时，对searchBar先resignFirstResponse再becomeFirstResponse
        
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
extension SearchControllerForTableHeaderViewController: UITableViewDataSource {
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
extension SearchControllerForTableHeaderViewController: UISearchControllerDelegate {
    func willPresentSearchController(_ searchController: UISearchController) {
        //若需要在无输入时亦展示searchResultsController.view,需执行此句,必须在主线程中执行
        DispatchQueue.main.async { () -> Void in
            searchController.searchResultsController!.view.isHidden = false;
        }
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //对于由代码主动发起的searchController进入active状态，需在此设置        searchController.searchBar.becomeFirstResponder()
    }
}

//MARK: UISearchBarDelegate
extension SearchControllerForTableHeaderViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //点击键盘上的搜索按钮时执行此代理，可按实际需求进行处理
        print("didClickSearchBuuton")
    }
}

//MARK: SearchResultsControllerDelegate
extension SearchControllerForTableHeaderViewController: SearchResultsControllerDelegate {
    func didClickResult(_ searchResultsController: SearchResultsController, didSelectRowAtIndexPath indexPath: IndexPath) {
        searchControllerForTableHeaderView.isActive = false
        
        //延时0.5s，确保transition animation完成，防止产生UI异常
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
