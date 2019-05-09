//
//  listVC.swift
//  ib2d2
//
//  Created by balon on 4/28/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import CoreData

class listVC: UIViewController{
    @IBOutlet weak var tableView: UITableView!
    var backups = [Backups]()
    var selected: Int?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Selected all entries from CoreData
        let fetchRequest = NSFetchRequest<Backups>(entityName: "Backups")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        do {
            backups = try context.fetch(fetchRequest) as [Backups]
        } catch {
            print("error")
        }
        
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selectedItem") {
            let vc = segue.destination as! displayVC
            vc.backup = backups[selected!]
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Browse", image: UIImage(named: "list"), tag: 1)
    }

}

extension listVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
        tableView.endUpdates()
    }
}

extension listVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BackupCell") as? BackupTableCellTableViewCell else { fatalError("Unexpected Index Path")}
        //let backup = backupsFetchedResultsController.object(at: indexPath)
        let backup = backups[indexPath.row]
        
        cell.titleLabel?.text = backup.backupTitle
        cell.timeLabel?.text = backup.timeStamp
        return cell
    }
    
    func tableView(_ tableView:UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath.row
        
        self.performSegue(withIdentifier: "selectedItem", sender: self)
    }
    
}

extension listVC: UITableViewDataSource {
    // how many sections are there
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    // how many cells are there
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //guard let backups = backupsFetchedResultsController.fetchedObjects else { return 0 }
        return backups.count
    }
}
