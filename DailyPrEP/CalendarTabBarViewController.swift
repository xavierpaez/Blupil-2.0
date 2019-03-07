//
//  CalendarTabBarViewController.swift
//  DailyPrEP
//
//  Created by Xavier Paez on 2/18/17.
//  Copyright © 2017 XavierPaez. All rights reserved.
//

import UIKit

class CalendarTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor(colorWithHexValue: 0x2BA4FF)
//        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.removeTabbarItemsText()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeTabbarItemsText() {
        if let items = self.tabBar.items {
            for item in items {
                item.title = ""
                item.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0);
            }
        }
    }

}
