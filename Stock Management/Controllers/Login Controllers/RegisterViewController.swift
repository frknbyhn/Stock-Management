//
//  RegisterViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 20
        emailTextField.backgroundColor = .clear
        emailTextField.alpha = 1
        emailTextField.layer.borderWidth = 1
        
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 20
        emailTextField.backgroundColor = .clear
        passwordTextField.alpha = 1
        passwordTextField.layer.borderWidth = 1
        
        retypePasswordTextField.clipsToBounds = true
        retypePasswordTextField.layer.cornerRadius = 20
        emailTextField.backgroundColor = .clear
        retypePasswordTextField.alpha = 1
        retypePasswordTextField.layer.borderWidth = 1
        registerButton.layer.cornerRadius = 20
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        if passwordTextField.text != retypePasswordTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Password doesn't match", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            }
        else{
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    let alertController = UIAlertController(title: "Congratulations", message: "You've succesfully registered.", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateInitialViewController()
                    UIApplication.shared.keyWindow?.rootViewController = vc
                }else{
                    let alertController = UIAlertController(title: "Hata", message: "Please check your info", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    
    
    
}
