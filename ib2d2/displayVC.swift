//
//  displayVC.swift
//  ib2d2
//
//  Created by balon on 5/8/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import CoreData

class displayVC: UIViewController {
    var backup:Backups?
    
    // Visuals
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var fileText: UILabel!
    @IBOutlet weak var localText: UILabel!
    @IBOutlet weak var cloudText: UILabel!
    
    // Used for CoreData
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Handling all settings
    var bucketName: String = ""
    var accId: String = ""
    var appKey: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = backup!.backupTitle
        
        // Get all of our stuff from backblaze!
        let settings = fetchSettings()
        let download:BackBlaze
        
        // Check the settings, then init the backblaze object
        if settings.count > 0{
            // good we have settings we can continue
            var settingsData:NSManagedObject? = nil
            
            // unpack the data object from the settings
            for data in settings.data as! [NSManagedObject]{
                settingsData = data
                break              // should only be one entry.. but let's be sure
            }
            
            // get all of our information we stored in CoreData
            bucketName = settingsData?.value(forKey:"bucketName" ) as! String
            accId = settingsData?.value(forKey:"accountId") as! String
            appKey = settingsData?.value(forKey:"applicationKey") as! String
            
            // we got all our settings, lets make the backblaze object
            download = BackBlaze(ai: accId, ak: appKey, bn: bucketName)
        } else {
            alertBadSettings()
            return
        }

        let dlPath = download.download(fileID: backup!.bbFileID!)
        
        if backup!.isImage == true{
            imageView.image = UIImage(contentsOfFile: dlPath)
        } else {
            imageView.image = UIImage(named: "selectMedia")
        }
  
        descText.text = backup!.backupDesc
        fileText.text = backup!.bbFileID
        localText.text = backup!.isLocal ? "True" : "False"
        cloudText.text = backup!.isCloud ? "True" : "False"
    }
    

    @IBAction func deleteButton(_ sender: Any) {
        alertComingSoon()
    }
    
    // ------ fetchSettings(): return result and count
    func fetchSettings() -> (data: Array<Any>?, count: Int) {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSettings")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            return (result, result.count)
        } catch {
            print("[Error] Unable to fetch results")
        }
        
        return (nil, 0)
    }
    
    
    // ------ alertComingSoon(): Prompt message
    func alertComingSoon(){
        // create the alert
        let alert = UIAlertController(title: "Comming Soon", message: "Currently you cannot delete your backups from the app!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------ alertBadSettings(): Something is wrong!
    func alertBadSettings(){
        // create the alert
        let alert = UIAlertController(title: "Settings Error", message: "Your settings are incorrect or otherwise invalid.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
