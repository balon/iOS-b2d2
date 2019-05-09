//
//  settingsVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import CoreData

class settingsVC: UIViewController {
    @IBOutlet weak var saveStyle: UIButton!
    @IBOutlet weak var logStyle: UIButton!
    @IBOutlet weak var legalStyle: UIButton!
    @IBOutlet weak var docStyle: UIButton!
    
    @IBOutlet weak var textBucketName: UITextField!
    @IBOutlet weak var textAccountId: UITextField!
    @IBOutlet weak var textAccountKey: UITextField!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styles ----------------------
        saveStyle.layer.cornerRadius = 8
        logStyle.layer.cornerRadius = 6
        legalStyle.layer.cornerRadius = 6
        docStyle.layer.cornerRadius = 6
        
        updateTextFields()
    }
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named: "settings"), tag: 1)
    }
    
    // ------ updateTextFields(): See if anything has changed to show users
    func updateTextFields(){
        let settings = fetchSettings()
        if settings.count > 0{
            placeholdExisting(settings: settings.data!)
        }
    }
    
    // ------ saveSettings(): Get the user's input and save it to CoreData
    @IBAction func saveSettings(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        let usrBucketName = textBucketName.text!
        let usrAccountId = textAccountId.text!
        let usrAppKey = textAccountKey.text!
        
        if usrBucketName == "" {
            alertBadInput()
            return
        } else if usrAccountId == "" {
            alertBadInput()
            return
        } else if usrAppKey == "" {
            alertBadInput()
            return
        }
        
        // Delete existing settings, it's time to update them...
        clearSettings()
        
        // Get the data and set our new app settings!
        let entity = NSEntityDescription.entity(forEntityName: "AppSettings", in: context)
        let newSettings = NSManagedObject(entity: entity!, insertInto: context)
        newSettings.setValue(usrBucketName, forKey: "bucketName")
        newSettings.setValue(usrAccountId, forKey: "accountId")
        newSettings.setValue(usrAppKey, forKey: "applicationKey")
        
        do {
            try context.save()
            alertSaveSuccess()
            textBucketName.text = nil
            textAccountId.text = nil
            textAccountKey.text = nil
            updateTextFields()
            print("[Log] Inserted new item into CoreData")
        } catch {
            print("[Error] Could not save to device")
        }
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
    
    // ------ clearSettings(): delete all existing entries in CoreData
    func clearSettings(){
        let context = appDelegate.persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "AppSettings")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            let result = try context.execute(request)
            print(result)
        } catch {
            print("[Error] Could not clear CoreData")
        }
    }
    
    // ------ alertBadInput(): Tell the user they messed up!
    func alertBadInput(){
        // create the alert
        let alert = UIAlertController(title: "Bad Input", message: "Please make sure all fields are filled before saving your settings!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------ alertSaveSuccess(): Confirm settings saved!
    func alertSaveSuccess(){
        // create the alert
        let alert = UIAlertController(title: "Settings Saved", message: "Your settings were saved successfully.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------ placeholdExisting(): Update placeholders with existing settings
    func placeholdExisting(settings: Array<Any>){
        var settingsData:NSManagedObject? = nil
        
        // unpack the data object from the settings
        for data in settings as! [NSManagedObject]{
            settingsData = data
            break              // should only be one entry.. but let's be sure
        }
        let existBucketName = settingsData?.value(forKey:"bucketName" )
        let existAccountID = settingsData?.value(forKey:"accountId")

        textBucketName.placeholder = "Current: \(existBucketName!)"
        textAccountId.placeholder = "Current: \(existAccountID!)"
        textAccountKey.placeholder = "Current: **********[REDACTED]**********"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "legalWeb") {
            let vc = segue.destination as! webHandlerVC
            vc.webUrl = "https://www.backblaze.com/company/terms.html"
            vc.webTitle = "Terms of Service"
        }
        if (segue.identifier == "docWeb") {
            let vc = segue.destination as! webHandlerVC
            vc.webUrl = "https://github.com/balon/ib2d2/blob/master/README.md"
            vc.webTitle = "App Documentation"
        }
    }
    
    @IBAction func legalButton(_ sender: Any) {
        self.performSegue(withIdentifier: "legalWeb", sender: self)
    }
    
    @IBAction func docButton(_ sender: Any) {
        self.performSegue(withIdentifier: "docWeb", sender: self)
    }
}
