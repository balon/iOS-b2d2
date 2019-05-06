//
//  addVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit

class addVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    let imagePicker = UIImagePickerController()
    var selectedMedia: UIImage?
    var mediaPath: NSURL?
    var isImage: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Add New", image: UIImage(named: "add"), tag: 1)
    }
    
    /* button to add a new image or video */
    @IBAction func addImage(_ sender: Any) {
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
            let imageURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
            //let imagePath =  imageURL.path!
            //let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imagePath)
            mediaPath = imageURL
            isImage = true
        } else {
            // User selected a video
            print("Uploading a video")
            selectedMedia = info[.originalImage] as? UIImage
            let imageURL = info[UIImagePickerController.InfoKey.mediaURL] as! NSURL
            //let imagePath =  imageURL.path!
            //let localPath = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(imagePath)
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

}
