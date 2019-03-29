//
//  MakeSaleViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import Kingfisher

class MakeSaleViewController: BaseViewController {
    
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var productImageView: UIImageView!
    
    var comingProductID : String = ""
    var comingCustomerID : String = ""
    var comingCustomerSales : String = ""
    var uid = Auth.auth().currentUser?.uid
    var stock = Customers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        quantityTextField.clipsToBounds = true
        quantityTextField.layer.cornerRadius = 10
        quantityTextField.backgroundColor = .clear
        quantityTextField.alpha = 1
        quantityTextField.layer.borderWidth = 1
        
        sellButton.clipsToBounds = true
        sellButton.layer.cornerRadius = 10
        sellButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        sellButton.alpha = 1
        sellButton.setTitleColor(.white, for: UIControl.State.normal)
        
        let dataRef = Database.database().reference().child(uid!).child("Products").child(comingProductID).child("productImage")
        dataRef.observeSingleEvent(of: .value) { (snapshot) in
            let url = snapshot.value
            print("URL \(url!)")
            self.productImageView.kf.setImage(with: URL(string: "\(url!)"))
        }
    }
    
    
    @IBAction func sellButtonClicked(_ sender: Any) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let result = formatter.string(from: date)
        
        let stockRef = Database.database().reference().child(uid!).child("Customers").child(comingCustomerID)
        
        let secondKey = Database.database().reference().child(uid!).child("Customers").child(comingCustomerID).child("customerSales").childByAutoId().key
        
        let newRef = stockRef.child("customerSales").child(secondKey!)
        
        let customerRef = Database.database().reference().child(uid!).child("Customers").child(self.comingCustomerID)
        let dataRef = Database.database().reference().child(uid!).child("Products").child(comingProductID).child("productQuantity")
        
        dataRef.observeSingleEvent(of: .value) { (snapshot) in
            let sellQuantity = Int(self.quantityTextField.text!)
            let stock = "\(snapshot.value!)"
            let newStock = Int(stock)
            let newValue = newStock! - sellQuantity!
            
            customerRef.child("customerPurchaseQuantity").observeSingleEvent(of: .value, with: { (snapshot) in
                let existQuantity = "\(snapshot.value!)"
                let newExistQuantity = Int(existQuantity)
                let newQuantity = newExistQuantity! + sellQuantity!
                customerRef.child("customerPurchaseQuantity").setValue(newQuantity)
            })
            
        if  sellQuantity! < newStock! || sellQuantity! == newStock! {
                
                let alert = UIAlertController(title: "Congratulations", message: "Sale Completed", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Go Main Page", style: .default, handler: { (action) in
                    
                    self.popToRoot()
                    if newValue == 0 {
                        let alert = UIAlertController(title: "Congratulations", message: "All products have been sell", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "You can add new products", style: .default, handler: { (action) in
                            self.popToRoot()
                        })
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                        let deleteRef = Database.database().reference().child(self.uid!).child("Products").child(self.comingProductID)
                        deleteRef.removeValue()
                    }
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
                dataRef.setValue(newValue)
                
            }else{
                let alert = UIAlertController(title: "Error", message: "You have \(sellQuantity!) piece in your stock. You can sell \(stock) piece ", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Try Again", style: .cancel, handler: { (action) in
                    self.quantityTextField.text = ""
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        let newSecondItems = [
            "Date" : result,
            "Quantity" : Int(self.quantityTextField.text!)!
            ] as [String : Any]
        newRef.setValue(newSecondItems)
    }
    
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
