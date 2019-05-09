//
//  addVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import CoreData

class addVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    var selectedMedia: UIImage?
    var mediaPath: NSURL?
    var isImage: Bool?
    var failState: Bool = false
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var addButton: UIButton!

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        failState = false
        
        /* Now let's check for internet & settings... */
        // check internet
        if Reachability.isConnectedToNetwork(){
            print("Internet Connection Available!")
        }else{
            failState = true
            print("Internet Connection not Available!")
            alertNoInternet()
        }
        
        // check settings are set
        let settings = fetchSettings()
        if settings.count > 0{
            print("Settings found!")
        } else {
            failState = true
            alertNoSettings()
        }
        
        addLongPressGesture()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    
    // adding long pressure gesture (source: https://stackoverflow.com/a/51853099)
    @objc func longPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == UIGestureRecognizer.State.began {
            print("Detected long press... reloading view!")
            print(failState)
            failState = true
            self.viewDidLoad()
            self.viewWillAppear(true)
        }
    }
    
    func addLongPressGesture(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
        longPress.minimumPressDuration = 1.5
        self.addButton.addGestureRecognizer(longPress)
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
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Add New", image: UIImage(named: "add"), tag: 1)
    }
    
    /* button to add a new image or video */
    @IBAction func addImage(_ sender: Any) {
        if failState == true{
            alertFailState()
            return
        }
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image", "public.movie"]

        present(imagePicker, animated: true, completion: nil)
    }
    
    
    // Delegate methods (per Apple iOS Documentation)
    @objc func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if(info[UIImagePickerController.InfoKey.mediaType] as? String == "public.image"){
            // User selected an image
            print("Uploading an image")
            selectedMedia = info[.originalImage] as? UIImage
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! NSURL
            mediaPath = imageURL
            isImage = true
        } else {
            // User selected a video
            print("Uploading a video")
            selectedMedia = info[.originalImage] as? UIImage
            let imageURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
            mediaPath = imageURL
            isImage = false
        }
        
        dismiss(animated: true, completion: sendToCreate)
    }
    
    func sendToCreate(){
        self.performSegue(withIdentifier: "createBackupSeg", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "createBackupSeg") {
            let vc = segue.destination as! createVC
            vc.selectedMedia = selectedMedia
            vc.mediaPath = mediaPath
            vc.isImage = isImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    // Alert you must reload
    func alertFailState(){
        // create the alert
        let alert = UIAlertController(title: "Fail State Detected", message: "Before adding new images, long-press the add button to check configuration options again.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // Alert if there is no internet!
    func alertNoInternet(){
        // create the alert
        let alert = UIAlertController(title: "Connectivity Error", message: "We could not connect to a network. Long-press the add button to re-check.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    // Alert if we could not find settings!
    func alertNoSettings(){
        // create the alert
        let alert = UIAlertController(title: "Settings Not Found", message: "No settings were found. Long-press the add button to re-check.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
