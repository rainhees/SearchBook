//
//  TabControl.swift
//  SearchBook
//
//  Created by Kang on 2021/07/02.
//

import UIKit

class TabControlVC: UITabBarController {
    
    override func viewDidLoad() {
        self.title = "Search"
        
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.title = item.title
    }
}
