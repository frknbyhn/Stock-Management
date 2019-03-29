//
//  MapViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

//MAP API KEY
import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseAuth
import MapKit
import CoreLocation

class MapViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var customerName: UILabel!
    
    var requestCLLocation = CLLocation()
    var locationManager = CLLocationManager()
    var stock = [Customers]()
    
    var lat : Double?
    var lon : Double?
    var address : String?
    var uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var customerTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webReq()
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        self.customerTableView.register(UINib(nibName: "CustomersTableViewCell", bundle: nil), forCellReuseIdentifier: "customerCell")
        customerTableView.delegate = self
        customerTableView.dataSource = self
    }
    
    func webReq(){
        let stockRef = Database.database().reference().child(uid!).child("Customers")
        stockRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let stockDict = snap.value as! [String:Any]
                let stock = Customers()
                stock.customerAddress = (stockDict["customerAddress"] as? String)!
                stock.customerName = (stockDict["customerName"] as? String)!
                stock.customerOwner = (stockDict["customerOwner"] as? String)!
                stock.customerPhone = (stockDict["customerPhone"] as? String)!
                stock.customerID = snap.key
                self.stock.append(stock)
                self.customerTableView.reloadData()
            }
            if self.stock.count == 0 {
                let alert : UIAlertController = UIAlertController(title: "Stock Management", message: "Add a customer before you can view the map.", preferredStyle: .alert)
                let okay : UIAlertAction = UIAlertAction(title: "Add Customer", style: .default) { (action) in
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "customerAddView") as! AddCustomerViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let denied = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(okay)
                alert.addAction(denied)
                self.present(alert, animated: true, completion: nil)
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
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        self.requestCLLocation = CLLocation(latitude: self.lat!, longitude: self.lon!)
        
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = "\(self.address!)"
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                        
                    }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customerName.text = stock[indexPath.row].customerName
        let customerID = stock[indexPath.row].customerID
        let dataRef = Database.database().reference().child(uid!).child("Customers").child(customerID)
        let latRef = dataRef.child("customerLat")
        let lonRef = dataRef.child("customerLon")
        dataRef.child("customerAddress").observeSingleEvent(of: .value) { (snapshot) in
            self.address = "\(snapshot.value!)"
        }
        latRef.observeSingleEvent(of: .value) { (snapshot) in
            self.lat = snapshot.value as? Double
            lonRef.observeSingleEvent(of: .value) { (snapshot) in
                self.lon = snapshot.value as? Double
                let annotation = MKPointAnnotation()
                let coordinate = CLLocationCoordinate2D(latitude: self.lat! , longitude: self.lon!)
                annotation.coordinate = coordinate
                annotation.title = self.stock[indexPath.row].customerName
                annotation.subtitle = self.stock[indexPath.row].customerOwner
                self.mapView.addAnnotation(annotation)
                self.mapView.zoomToLocation(location: annotation.coordinate)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stock.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerTableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomersTableViewCell
        cell.addressLabel.text = stock[indexPath.row].customerAddress
        cell.customerNameLabel.text = stock[indexPath.row].customerName
        cell.ownerLabel.text = stock[indexPath.row].customerOwner
        cell.phoneLabel.text = stock[indexPath.row].customerPhone
        cell.toCustomerButton.isHidden=true
        return cell
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
