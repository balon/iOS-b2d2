//
//  backupsVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit

class backupsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "3-2-1", image: UIImage(named: "cloud"), tag: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "321web") {
            let vc = segue.destination as! webHandlerVC
            vc.webUrl = "https://www.backblaze.com/blog/the-3-2-1-backup-strategy"
            vc.webTitle = "BackBlaze on 3-2-1"
        }
    }
    
    @IBAction func infoButton(_ sender: Any) {
        self.performSegue(withIdentifier: "321web", sender: self)
    }

}
