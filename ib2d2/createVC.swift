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
    var selectedMedia: UIImage?
    var mediaPath: NSURL?
    var isImage: Bool?
    @IBOutlet weak var mediaView: UIImageView!
    @IBOutlet weak var descText: UITextView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var uploadStyle: UIButton!
    
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
}
