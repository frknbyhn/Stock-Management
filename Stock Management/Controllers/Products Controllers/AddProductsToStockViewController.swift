//
//  AddProductsToStockViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import MobileCoreServices

class AddProductsToStockViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var productDescTextField: UITextField!
    @IBOutlet weak var stockTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var uploadProgressBar: UIProgressView!
    @IBOutlet weak var percentageLabel: UILabel!

    weak var delegate : HomeRefresherDelegate?

    var stock : Products?
    var comingIndex : Int?
    var newPic : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadProgressBar.setProgress(0, animated: false)
        uploadProgressBar.isHidden = true
        percentageLabel.isHidden = true
        
        addButton.clipsToBounds = true
        addButton.layer.cornerRadius = 10
        addButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        addButton.alpha = 1
        addButton.setTitleColor(.white, for: UIControl.State.normal)
        
        pickImageButton.clipsToBounds = true
        pickImageButton.layer.cornerRadius = 10
        pickImageButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        pickImageButton.alpha = 1
        pickImageButton.setTitleColor(.white, for: UIControl.State.normal)
        
        priceTextField.clipsToBounds = true
        priceTextField.layer.cornerRadius = 10
        priceTextField.backgroundColor = .clear
        priceTextField.alpha = 1
        priceTextField.layer.borderWidth = 1
        
        productNameTextField.clipsToBounds = true
        productNameTextField.layer.cornerRadius = 10
        productNameTextField.backgroundColor = .clear
        productNameTextField.alpha = 1
        productNameTextField.layer.borderWidth = 1
        
        productDescTextField.clipsToBounds = true
        productDescTextField.layer.cornerRadius = 10
        productDescTextField.backgroundColor = .clear
        productDescTextField.alpha = 1
        productDescTextField.layer.borderWidth = 1
        
        stockTextField.clipsToBounds = true
        stockTextField.layer.cornerRadius = 10
        stockTextField.backgroundColor = .clear
        stockTextField.alpha = 1
        stockTextField.layer.borderWidth = 1
    }
    
    @IBAction func addButtonClicked(_ sender: Any) {
        
        let key = Database.database().reference().child(uid!).child("Products").childByAutoId().key
        
        let stockRef = Database.database().reference().child(uid!).child("Products").child(key!)
        
        let storageRef = Storage.storage().reference().child(uid!).child("\(productNameTextField.text!).jpeg")
        
        let uploadObject = productImageView.image!.jpegData(compressionQuality: 1.0)
        
        let progress = storageRef.putData(uploadObject!, metadata: nil)
        
        uploadProgressBar.isHidden = false
        percentageLabel.isHidden = false

        storageRef.putData(uploadObject!, metadata: nil) { (metadata , error ) in
            if error != nil {
                print(error!)
                return
            }else{
                progress.observe(.progress){ snapshot in
                    let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                    print(percentComplete)
                    self.uploadProgressBar.setProgress(Float(percentComplete/100), animated: true)
                    let roundedPercentage = String(percentComplete.rounded())
                    self.percentageLabel.text = "%\(roundedPercentage)"
            }
            
        }
            progress.observe(.success) { snapshot in
                let alert = UIAlertController(title: "Congratulations", message: "Your product has succesfully added your stock.", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Go Main Page", style: .default, handler: { (action) in
                    self.uploadProgressBar.setProgress(0, animated: true)
                    self.percentageLabel.text = "Upload Succesful"
                    self.productImageView.image = #imageLiteral(resourceName: "products")
                    self.productNameTextField.text = ""
                    self.priceTextField.text = ""
                    self.productDescTextField.text = ""
                    self.stockTextField.text = ""
                    self.popToRoot()
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
            
            progress.observe(.failure) { snapshot in
                let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
                let okay = UIAlertAction(title: "Try Again", style: .cancel, handler: { (action) in
                })
                alert.addAction(okay)
                self.present(alert, animated: true, completion: nil)
            }
    
            storageRef.downloadURL(completion: { (url, error) in
            if error != nil {
                print(error!)
            }else {
                let newItems = [
                    "productName" : self.productNameTextField.text!,
                    "productDesc" : self.productDescTextField.text!,
                    "productQuantity" : Int(self.stockTextField.text!)!,
                    "productPrice" : "\(self.priceTextField.text!)₺",
                    "productImage" : "\(url!)"
                    ] as [String : Any]
                stockRef.setValue(newItems)
                }
            })
        }
        if percentageLabel.text == "Upload Succesful"{ percentageLabel.text = "Now you can upload new product" }
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickImageButtonClicked(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose photo", message: "", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = true
            }
        }
        let cameraRollAction = UIAlertAction(title: "Camera Roll", style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as String]
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
                self.newPic = false
            }
        }
        let denied = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
        }
        alert.addAction(cameraRollAction)
        alert.addAction(cameraAction)
        alert.addAction(denied)
        self.present(alert, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        if mediaType.isEqual(to: kUTTypeImage as String){
            let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            productImageView.image = image
            
            if newPic == true{
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageError), nil)
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func imageError(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer){
        if error != nil{
            let alert = UIAlertController(title: "Upload Failed", message: "Something went wrong when uploading the product", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    

}
