//
//  DataManager.swift
//  ib2d2
//
//  Created by balon on 5/8/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import Foundation

public class DataManager: UIApplicationDelegate{
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var entityName: String = ""

    init(requestedEntity: String){
        self.entityName = requestedEntity
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
}
