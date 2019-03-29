//
//  ToCustomerMapViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 27.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseAuth
import MapKit
import CoreLocation

class ToCustomerMapViewController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customerName: UILabel!

    var comingCustomerName : String = ""
    var comingCustomerOwner : String = ""
    var comingCustomerID : String = ""
    var requestCLLocation = CLLocation()
    var locationManager = CLLocationManager()
    var lat : Double?
    var lon : Double?
    var uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customerName.text = comingCustomerName
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let dataRef = Database.database().reference().child(uid!).child("Customers").child(comingCustomerID)
        let latRef = dataRef.child("customerLat")
        let lonRef = dataRef.child("customerLon")
        
        latRef.observeSingleEvent(of: .value) { (snapshot) in
            self.lat = snapshot.value as? Double
            lonRef.observeSingleEvent(of: .value) { (snapshot) in
                self.lon = snapshot.value as? Double
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: self.lat! , longitude: self.lon! )
                annotation.coordinate = coordinate
                annotation.title = self.comingCustomerName
                annotation.subtitle = self.comingCustomerOwner
                self.mapView.addAnnotation(annotation)
                self.mapView.zoomToLocation(location: annotation.coordinate)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseID = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.orange
            let button = UIButton(type: UIButton.ButtonType.infoDark)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D(latitude: self.lat!, longitude: self.lon!)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.requestCLLocation = CLLocation(latitude: self.lat!, longitude: self.lon!)
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            let dataRef = Database.database().reference().child(self.uid!).child("Customers").child(self.comingCustomerID).child("customerAddress")
            dataRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let address = snapshot.value
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        print("Address : \(address!)")
                        item.name = "\(address!)"
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                    }
                }
            })
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MKMapView {
    func zoomToUserLocation() {
        self.zoomToUserLocation(latitudinalMeters: 1000, longitudinalMeters: 1000)
    }
    func zoomToUserLocation(latitudinalMeters:CLLocationDistance,longitudinalMeters:CLLocationDistance){
        guard let coordinate = userLocation.location?.coordinate else { return }
        self.zoomToLocation(location: coordinate, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
    }
    func zoomToLocation(location : CLLocationCoordinate2D, latitudinalMeters:CLLocationDistance = 100, longitudinalMeters:CLLocationDistance = 100){
        let region = MKCoordinateRegion(center: location, latitudinalMeters: latitudinalMeters, longitudinalMeters: longitudinalMeters)
        setRegion(region, animated: true)
    }
}
