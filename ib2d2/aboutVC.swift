//
//  aboutVC.swift
//  ib2d2
//
//  Created by balon on 4/26/19.
//  Copyright © 2019 TJ balon. All rights reserved.
//

import UIKit
import MapKit
import Social

class aboutVC: UIViewController {

    /* Outlets & Constants we'll need */
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var fbStyle: UIButton!
    @IBOutlet weak var twStyle: UIButton!
    @IBOutlet weak var wbStyle: UIButton!
    
    let regionRadius: CLLocationDistance = 2500
    let initalLocation = CLLocation(latitude: 38.595504, longitude: -121.272839)
    let annotatePoint = CLLocationCoordinate2D(latitude: 38.595504, longitude: -121.272839)
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Load our map stuff */
        centerMapOnLocation(location: initalLocation)
        annotateDC()
        
        /* Round our buttons */
        fbStyle.layer.cornerRadius = 6
        twStyle.layer.cornerRadius = 6
        wbStyle.layer.cornerRadius = 6
    }
    
    /* Set the tab name + image */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "About", image: UIImage(named: "info"), tag: 1)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.mapType = MKMapType.standard
    }
    
    func annotateDC(){
        annotation.coordinate = annotatePoint
        annotation.title = "BackBlaze Datacenter"
        annotation.subtitle = "Sacramento, California"
        self.mapView.addAnnotation(annotation)
    }
    
    /* Social Medias + Web */
    @IBAction func fbButton(_ sender: Any) {
        print("fb button pressed")
        let facebookController = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
        facebookController?.setInitialText("Check out ib2d2 on the app store - powered by @BackBlaze!")
        present(facebookController!, animated:true, completion: nil)
    }
    
    @IBAction func twButton(_ sender: Any) {
        print("twitter button pressed")
        let twitterController = SLComposeViewController(forServiceType:SLServiceTypeTwitter)
        twitterController?.setInitialText("Check out ib2d2 on the app store - powered by @BackBlaze!")
        present(twitterController!, animated:true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "aboutWeb") {
            let vc = segue.destination as! webHandlerVC
            vc.webUrl = "https://backblaze.com"
            vc.webTitle = "BackBlaze Website"
        }
    }
    
    @IBAction func webButton(_ sender: Any) {
        self.performSegue(withIdentifier: "aboutWeb", sender: self)
    }
}
