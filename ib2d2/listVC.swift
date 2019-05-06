//
//  listVC.swift
//  ib2d2
//
//  Created by balon on 4/28/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit

class listVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "list"), tag: 1)
    }

}
