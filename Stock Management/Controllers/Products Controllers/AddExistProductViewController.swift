//
//  AddExistProductViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 25.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class AddExistProductViewController: BaseViewController {

    
    var stock = [Products]()
    var items = Products()
    var productID : String?
    var uid = Auth.auth().currentUser?.uid

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var changeStockTextField: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        addButton.alpha = 1
        addButton.setTitleColor(.white, for: UIControl.State.normal)
        
        resetButton.clipsToBounds = true
        resetButton.layer.cornerRadius = 10
        resetButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        resetButton.alpha = 1
        resetButton.setTitleColor(.white, for: UIControl.State.normal)
        
        stockTextField.clipsToBounds = true
        stockTextField.layer.cornerRadius = 10
        stockTextField.backgroundColor = .clear
        stockTextField.alpha = 1
        stockTextField.layer.borderWidth = 1
        
        priceTextField.clipsToBounds = true
        priceTextField.layer.cornerRadius = 10
        priceTextField.backgroundColor = .clear
        priceTextField.alpha = 1
        priceTextField.layer.borderWidth = 1
        
        descTextField.clipsToBounds = true
        descTextField.layer.cornerRadius = 10
        descTextField.backgroundColor = .clear
        descTextField.alpha = 1
        descTextField.layer.borderWidth = 1
        
        nameTextField.clipsToBounds = true
        nameTextField.layer.cornerRadius = 10
        nameTextField.backgroundColor = .clear
        nameTextField.alpha = 1
        nameTextField.layer.borderWidth = 1
        
        changeStockTextField.clipsToBounds = true
        changeStockTextField.layer.cornerRadius = 10
        changeStockTextField.backgroundColor = .clear
        changeStockTextField.alpha = 1
        changeStockTextField.layer.borderWidth = 1
        
        
        let dataRef = Database.database().reference().child(uid!).child("Products").child(productID!)
        
        dataRef.child("productDesc").observeSingleEvent(of: .value) { (snapshot) in
            let descText = "\(snapshot.value!)"
            self.descTextField.text = descText
        }
        
        dataRef.child("productName").observeSingleEvent(of: .value) { (snapshot) in
            let nameText = "\(snapshot.value!)"
            self.nameTextField.text = nameText
        }
        
        dataRef.child("productPrice").observeSingleEvent(of: .value) { (snapshot) in
            let priceText = "\(snapshot.value!)"
            self.priceTextField.text = priceText
        }
        
        
        dataRef.child("productImage").observeSingleEvent(of: .value) { (snapshot) in
            let url = snapshot.value
            print("URL \(url!)")
            self.productImageView.kf.setImage(with: URL(string: "\(url!)"))
            
        }
        
        dataRef.child("productQuantity").observeSingleEvent(of: .value) { (snapshot) in
            let existStock = "\(snapshot.value!)"
            self.changeStockTextField.text = existStock
        }
        
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let dataRef = Database.database().reference().child(uid!).child("Products").child(productID!)
        
        if self.descTextField.text != "" && self.nameTextField.text != "" && self.priceTextField.text != ""{
            let productQ = Int(self.changeStockTextField.text!)
            dataRef.child("productDesc").setValue(self.descTextField.text!)
            dataRef.child("productName").setValue(self.nameTextField.text!)
            dataRef.child("productPrice").setValue("\(self.priceTextField.text!)₺")
            dataRef.child("productQuantity").setValue(productQ)
            
            let alert = UIAlertController(title: "Congratulations", message: "Upload Succesful", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Go Main Page", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            let alert = UIAlertController(title: "Error", message: "Please fill information fields", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func setButtonClicked(_ sender: Any) {
        
        let dataRef = Database.database().reference().child(uid!).child("Products").child(productID!)
        
        if stockTextField.text != "" {
            dataRef.child("productQuantity").observeSingleEvent(of: .value) { (snapshot) in
                let sellQuantity = Int(self.stockTextField.text!)
                let stock = "\(snapshot.value!)"
                let newStock = Int(stock)
                let newValue = newStock! + sellQuantity!

                dataRef.child("productQuantity").setValue(newValue, withCompletionBlock: { (error, success) in
                    if error == nil {
                        let alert = UIAlertController(title: "Congratulations", message: "Upload Succesful", preferredStyle: .alert)
                        let okay = UIAlertAction(title: "Go Main Page", style: .default, handler: { (action) in
                            self.popToRoot()
                        })
                        alert.addAction(okay)
                        self.present(alert, animated: true, completion: nil)
                        
                    }else{
                        print("Hata \(error!.localizedDescription)")
                    }
                })
            }
        }else{
            let alert = UIAlertController(title: "Error", message: "Please fill the information fields", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Try Again", style: .default, handler: nil)
            alert.addAction(okay)
            self.present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func webReq(){
        let stockRef = Database.database().reference().child(uid!).child("Products")
        stockRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let stockDict = snap.value as! [String:Any]
                let stock = Products()
                stock.productDesc = (stockDict["productDesc"] as? String)!
                stock.productImage = (stockDict["productImage"] as? String)!
                stock.productName = (stockDict["productName"] as? String)!
                stock.productPrice = (stockDict["productPrice"] as? String)!
                stock.productQuantity = (stockDict["productQuantity"] as? Int)!
                self.stock.append(stock)
                stock.productID = snap.key
            }
        }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
