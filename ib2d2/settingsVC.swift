//
//  settingsVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit

class settingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 1)
    }
}
