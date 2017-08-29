//
//  ResultDetailViewController.swift
//  UISearchController
//
//  Created by 吕建廷 on 16/7/3.
//  Copyright © 2016年 吕建廷. All rights reserved.
//

import UIKit

class ResultDetailViewController: UIViewController {
    var result: String!

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
extension ResultDetailViewController {
    fileprivate func buildUserInterface() {
        let label = UILabel(frame: view.bounds)
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.text = result

        view.addSubview(label)
        
        view.backgroundColor = UIColor.white
    }
}
