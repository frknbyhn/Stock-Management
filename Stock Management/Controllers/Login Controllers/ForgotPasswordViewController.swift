//
//  ForgotPasswordViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 20
        
        sendButton.clipsToBounds = true
        sendButton.layer.cornerRadius = 20
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func sendButtonClicked(_ sender: Any) {
        sendPasswordReset(withEmail: emailTextField.text!)
        let alertController = UIAlertController(title: "Okay", message: "We've sent a link to reset your password to your e-mail address.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Thanks.", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func sendPasswordReset(withEmail email: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            callback?(error)
        }
    }
    

}
