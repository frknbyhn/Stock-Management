//
//  AddCustomerViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import GooglePlaces
import FirebaseAuth

class AddCustomerViewController: BaseViewController, GMSAutocompleteViewControllerDelegate {
    var uid = Auth.auth().currentUser?.uid


    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var customerNameTextField: UITextField!
    
    @IBOutlet weak var addButton: UIButton!
    
    
    weak var delegate : HomeRefresherDelegate?

    var stock : Customers?
    var comingIndex : Int?
    var placeLat : Double?
    var placeLon : Double?

    override func viewDidLoad() {
        super.viewDidLoad()

        

        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        addButton.alpha = 1
        addButton.setTitleColor(.white, for: UIControl.State.normal)

        customerNameTextField.clipsToBounds = true
        customerNameTextField.layer.cornerRadius = 10
        customerNameTextField.backgroundColor = .clear
        customerNameTextField.alpha = 1
        customerNameTextField.layer.borderWidth = 1
        
        ownerTextField.clipsToBounds = true
        ownerTextField.layer.cornerRadius = 10
        ownerTextField.backgroundColor = .clear
        ownerTextField.alpha = 1
        ownerTextField.layer.borderWidth = 1
        
        phoneTextField.clipsToBounds = true
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.backgroundColor = .clear
        phoneTextField.alpha = 1
        phoneTextField.layer.borderWidth = 1
        
        addressTextField.clipsToBounds = true
        addressTextField.layer.cornerRadius = 10
        addressTextField.backgroundColor = .clear
        addressTextField.alpha = 1
        addressTextField.layer.borderWidth = 1
    }
    
    @IBAction func addressTextClicked(_ sender: Any) {
        addressTextField.resignFirstResponder()
        let acController = GMSAutocompleteViewController()
        acController.delegate = self
        present(acController, animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        placeLat = place.coordinate.latitude
        placeLon = place.coordinate.longitude
        addressTextField.text = place.name
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error : \(error.localizedDescription)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let key = Database.database().reference().child(uid!).child("Customers").childByAutoId().key

        let stockRef = Database.database().reference().child(uid!).child("Customers").child(key!)
        
        let newItems = [
            "customerAddress" : self.addressTextField.text!,
            "customerName" : self.customerNameTextField.text!,
            "customerPhone" : self.phoneTextField.text!,
            "customerOwner" : self.ownerTextField.text!,
            "customerPurchaseQuantity" : 0,
            "customerLat" : placeLat!,
            "customerLon" : placeLon!
            ] as [String : Any]

        stockRef.updateChildValues(newItems) { (error, succes) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Try Again", style: .default , handler: { (action) in
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "Congratulations", message: "Upload Succesful", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Go Main Page", style: .default, handler: { (action) in
                    self.ownerTextField.text = ""
                    self.phoneTextField.text = ""
                    self.addressTextField.text = ""
                    self.customerNameTextField.text = ""
                    self.popToRoot()
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        
        
        stockRef.child("customerName").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.value == nil {
                stockRef.removeValue()
            }
        }
        
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }    
}
