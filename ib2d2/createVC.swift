//
//  createVC.swift
//  ib2d2
//
//  Created by balon on 5/5/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreData


extension UIImage {
    // overlay play button on image (source: https://stackoverflow.com/a/45915787)
    func overlayed(with overlay: UIImage) -> UIImage? {
        defer {
            UIGraphicsEndImageContext()
        }
        
        /* where to put our button and how to*/
        let playButtonSZ = CGSize(width: 100, height: 100)
        let centerView = CGPoint(x: size.width/2 - 50, y: size.height/2 - 50)
        
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        overlay.draw(in: CGRect(origin: centerView, size: playButtonSZ))
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            return image
        }
        return nil
    }
    
    // programatically set alpha (source: https://stackoverflow.com/a/28517867)
    func alpha(_ value:CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}


class createVC: UIViewController {
    // Passed variables from addVC
    var selectedMedia: UIImage?
    var mediaPath: NSURL?
    var isImage: Bool?
    
    // View Oulets
    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var uploadStyle: UIButton!
    
    
    // Used for CoreData
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Handling all settings
    var bucketName: String = ""
    var accId: String = ""
    var appKey: String = ""
    
    // Set a variable each time to prevent mutliple uploads
    var isUploaded:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
                
        /* Styling things */
        uploadStyle.layer.cornerRadius = 8
        descText.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descText.layer.borderWidth = 1.0
        descText.layer.cornerRadius = 5
        
        
        /* Configure preview settings */
        mediaView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        mediaView.contentMode = .scaleAspectFit
        mediaView.clipsToBounds = true
        
        
        /* Fill in preview with image */
        if isImage == true {
            mediaView.image = selectedMedia
        } else {
            let imgThumbnail = videoSnapshot(url: mediaPath!)
            mediaView.image = imgThumbnail
        }
        
    }

    // button to call the backblaze run routine
    @IBAction func uploadButton(_ sender: Any) {
        if titleText.text == ""{
            alertNoTitle()
            return
        }
        
        if isUploaded == false{
            isUploaded = true
        } else {
            // display error
            alertUploadedAlready()
            return
        }
        
        let settings = fetchSettings()
        let backup:BackBlaze
        
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
            backup = BackBlaze(ai: accId, ak: appKey, bn: bucketName)
        } else {
            alertBadSettings()
            return
        }
        
        // Let's prepare the file for backup...
        /* Variables we need to fulfill */
        let timeStamp: String = currTime()
        let uploadTitle = titleText.text
        let uploadDesc = descText.text
        var data: Data
        var fileName: String
        var fileType: String
        var hash: String
        // data: Data, fileName: String, fileType: String, sha1: String
        if isImage == true{
            // It is an image, do all of the image prep
            fileType = "image/jpeg"
            fileName = "photo-\(timeStamp).jpg"
            data = selectedMedia!.jpegData(compressionQuality: 6.0)!
            hash = sha1(data:data)
        } else {
            // It is a video, do all of the video prep
            fileType = "video/mp4"
            fileName = "video-\(timeStamp).mp4"
            do {
                data = try NSData(contentsOf: mediaPath! as URL) as Data
                hash = sha1(data:data)
            } catch {
                print("failed to convert video data")
                return
            }
        }
        
        let fileId = backup.upload(data: data, fileName: fileName, fileType: fileType, sha1: hash)
        uploadStyle.setTitle(" UPLOADED!", for: UIControl.State.normal)
        
        dbBackup(time: timeStamp, title: uploadTitle!, desc: uploadDesc!, id: fileId, isCloud: false, cloudPath: "nil", isLocal: false, localPath: "nil", imageStatus: self.isImage!)
        alertUploadSuccess()
    }
    
    
    // ------ dbBackup(): log into the CoreData 'DB' we've backed something up
    func dbBackup(time: String, title: String, desc: String, id: String, isCloud: Bool, cloudPath: String, isLocal: Bool, localPath: String, imageStatus: Bool){
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Backups", in: context)
        let newBackup = NSManagedObject(entity: entity!, insertInto: context)
        
        newBackup.setValue(time, forKey: "timeStamp")
        newBackup.setValue(title, forKey: "backupTitle")
        newBackup.setValue(desc, forKey: "backupDesc")
        newBackup.setValue(id, forKey: "bbFileID")
        newBackup.setValue(isCloud, forKey: "isCloud")
        newBackup.setValue(cloudPath,forKey: "cloudPath")
        newBackup.setValue(isLocal, forKey: "isLocal")
        newBackup.setValue(localPath, forKey: "localPath")
        newBackup.setValue(imageStatus, forKey: "isImage")
                
        do {
            try context.save()
        } catch {
            print("[ERROR] Failed to save to CoreData.")
            print("[WARN] Un-Recorded backup saved to storage!")
        }

    }
    
    // ------ sha1(): sha data (pulled from variety of sources.. had to edit to my own)
    func sha1(data: Data) -> String {
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA1($0, CC_LONG(data.count), &digest)
        }
        let hexBytes = digest.map { String(format: "%02hhx", $0) }
        return hexBytes.joined()
    }
    
    // ------ currTime(): give the current timestamp
    func currTime () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
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
    
    // get snapshot of video (source: https://stackoverflow.com/a/31898740)
    private func videoSnapshot(url: NSURL) -> UIImage? {
        
        let asset = AVAsset(url: url as URL)
        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value, 2)
        
        do {
            let imageRef = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: imageRef)
            return image.overlayed(with: UIImage(named: "playButton")!.alpha(0.5))
            
        } catch {
            print("error")
            return nil
        }
    }
    
    
    // ------ alertUploadedAlready(): Something is wrong!
    func alertUploadedAlready(){
        // create the alert
        let alert = UIAlertController(title: "Double Upload Detected", message: "You already uploaded this file, hit back and try again!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // ------ alertUploadSuccess(): file uploaded successfully
    func alertUploadSuccess(){
        // create the alert
        let alert = UIAlertController(title: "Backup Successful", message: "Your file was backed up to BackBlaze Successfully!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------ alertBadSettings(): Something is wrong!
    func alertBadSettings(){
        // create the alert
        let alert = UIAlertController(title: "No Settings", message: "Settings were not found, set them in the Settings tab.", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // ------ alertNoTitle(): There is no title
    func alertNoTitle(){
        // create the alert
        let alert = UIAlertController(title: "No Title", message: "Each backup is required to have a title set!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
