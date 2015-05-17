//
//  LocationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 3/1/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LocationViewController: BaseViewController,
    MKMapViewDelegate,
    CLLocationManagerDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    let locationManager = CLLocationManager()
    var logoImageCache: UIImage! = UIImage()
    var activities: AnyObject!

    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let activity = self.activities as? Shop {
            println("[+] \(activity.address)")
        } else {
            println("Error")
        }
        
        loadData()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func currentLocation(sender: AnyObject) {
        performWithCurrentLocation()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
        customNavigationBar()
        customLocation()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("LOCATION")
        
        let directionBarButtonItem: UIBarButtonItem! = UIBarButtonItem(title: "Directions", style: .Plain, target: self, action: "performWithDirectionLocation")
        navigationItem.rightBarButtonItems = [directionBarButtonItem]
    }
    
    func customLocation() -> Void {
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        reverseGeocodeLocation(CLLocation(latitude: 13.65197808, longitude: 100.49744396))
        
//        if let activity = self.activities {
//            let latitude: CLLocationDegrees! = Double((activity.latitude! as NSString).doubleValue)
//            let longitude: CLLocationDegrees! = Double((activity.longitude! as NSString).doubleValue)
//            let geoLocation: CLLocation! = CLLocation(latitude: latitude, longitude: longitude)
//            println("[+] LA: \(latitude) | LO: \(longitude)")
//            reverseGeocodeLocation(geoLocation)
//        } else {
//            println("[+] No value")
//        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func reverseGeocodeLocation(location: CLLocation!) -> Void {
        // Convert address to coordinate and annotate it on map
        let geoCoder: CLGeocoder! = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: {
            (placemarks, error) in
            
            if (error != nil) {
                println(error)
                return
            }
            
            if (placemarks != nil && placemarks.count > 0) {
                let placemark = placemarks[0] as! CLPlacemark
                
                // Add Annotation
                let annotation = MKPointAnnotation()
                annotation.title = "Momots"
                annotation.subtitle = "Cafe"
                annotation.coordinate = placemark.location.coordinate
                
                self.addressLabel.text = "Latitude: \(placemark.location.coordinate.latitude)   Longitude: \(placemark.location.coordinate.longitude)"
                
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        })
    }
    
    func getUserCurrentLocation() -> Void {
        let spanX: Double! = 0.00725
        let spanY: Double! = 0.00725
        let spanXLatitude: CLLocationDegrees! = spanX
        let spanYLongitude: CLLocationDegrees! = spanY
        
        let locationCoordinate2D: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)
        let coordinateSpan: MKCoordinateSpan! = MKCoordinateSpan(latitudeDelta: spanXLatitude, longitudeDelta: spanYLongitude)
        let region: MKCoordinateRegion! = MKCoordinateRegion(center: locationCoordinate2D, span: coordinateSpan)
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func displayLocationInfo(placemark: CLPlacemark!) {
        if (placemark != nil) {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            
            let locality = (placemark.locality != nil) ? placemark.locality : ""
            let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : ""
            let administrativeArea = (placemark.administrativeArea != nil) ? placemark.administrativeArea : ""
            let country = (placemark.country != nil) ? placemark.country : ""
            
            println("[Locality] \(locality)")
            println("[Postal code] \(locality)")
            println("[Administrative area] \(administrativeArea)")
            println("[Country] \(country)")
        }
    }
    
    func performWithCurrentLocation() -> Void {
        println("[User location] \(self.mapView.userLocation.coordinate.latitude) | \(self.mapView.userLocation.coordinate.longitude)")
        getUserCurrentLocation()
    }
    
    func performWithDirectionLocation() -> Void {
        let alertController = UIAlertController(title: "Choose the app that you'd like to open", message: nil, preferredStyle: .ActionSheet)
        
        let latitude: CLLocationDegrees! = 13.65197808
        let longitude: CLLocationDegrees! = 100.49744396
        
        let coordinate: CLLocationCoordinate2D! = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[Log] Cancel ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let feedbackAction = UIAlertAction(title: "Apple Maps", style: .Default) { (action) in
            self.performWithAppleMaps(coordinate, title: "Momots")
        }
        alertController.addAction(feedbackAction)
        
        let shareAction = UIAlertAction(title: "Google Maps", style: .Default) { (action) in
            self.performWithGoogleMaps(coordinate, title: "Momots")
        }
        alertController.addAction(shareAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func closeLocation() -> Void {
        dismissViewControllerAnimated(true, completion: nil)//"unwindCloseWithFeedbackViewController:"
    }
    
    func performWithAppleMaps(coordinate: CLLocationCoordinate2D!, title: String!) -> Void {
        println("[Log] Apple Maps: \(title) Latitude: \(coordinate.latitude)| Longitude: \(coordinate.longitude)")
        
        let placemark: MKPlacemark! = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        var mapItem: MKMapItem! = MKMapItem(placemark: placemark)
        mapItem.name = title
        mapItem.openInMapsWithLaunchOptions(nil)
    }
    
    func performWithGoogleMaps(coordinate: CLLocationCoordinate2D!, title: String!) -> Void {
        println("[Log] Google Maps: \(title) Latitude: \(coordinate.latitude)| Longitude: \(coordinate.longitude)")
        
        let url: NSURL! = NSURL(string: "comgooglemaps://?daddr=\(coordinate.latitude),\(coordinate.longitude)&directionsmode=driving")
        let urlAppLink: NSURL! = NSURL(string: "itms-apps://itunes.apple.com/en/app/google-maps/id585027354?mt=8")
        
        if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
            UIApplication.sharedApplication().openURL(url)
        } else {
            println("[Log] Google Maps app is not installed.")
            alertControllerWithAppLink("Application Not Found", message: "Google Maps is not installed on this device.", urlAppLink: urlAppLink)
        }
    }
    
    func alertControllerWithAppLink(title: String!, message: String!, urlAppLink: NSURL!) -> Void {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Close", style: .Cancel) { (action) in
            println("[Log] Close Alert")
        }
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction(title: "Go to App Store", style: .Default) { (action) in
            println("[Log] Go to App Store")
            UIApplication.sharedApplication().openURL(urlAppLink)
        }
        alertController.addAction(confirmAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: MKMapView delegate
    // ------------------------------
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let identifier = "ShopPin"
        
        if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
        }
        
        let leftIconView = UIImageView(frame: CGRectMake(0, 0, 53, 53))
        annotationView.image = UIImage(named: "00_pin")
        leftIconView.image = UIImage(named: "06_logoDummy")
        annotationView.leftCalloutAccessoryView = leftIconView
        
        return annotationView
    }
    
    // ------------------------------
    // MARK: -
    // MARK: CLLocationManager delegate
    // ------------------------------
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)-> Void in
            if (error != nil) {
                println("Reverse geocoder failed with error \(error.localizedDescription)")
                return
            }
            
            if (placemarks.count > 0) {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder.")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location \(error.localizedDescription)")
    }
}
