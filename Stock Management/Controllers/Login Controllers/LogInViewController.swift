//
//  LogInViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotYourPassword: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.clipsToBounds = true
        emailTextField.layer.cornerRadius = 20
        emailTextField.backgroundColor = .clear
        emailTextField.layer.borderWidth = 1
        emailTextField.alpha = 1
        
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.borderWidth = 1
        passwordTextField.alpha = 1
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 20
        loginButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        loginButton.alpha = 1
        loginButton.setTitleColor(.white, for: UIControl.State.normal)
        
        forgotYourPassword.setTitleColor(UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1), for: UIControl.State.normal)
        forgotYourPassword.layer.cornerRadius = 20
    }
    
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "forgotPasswordPage") as! ForgotPasswordViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonClicked(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error == nil {
                
                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateInitialViewController()
                UIApplication.shared.keyWindow?.rootViewController = vc
                
            }else{
                
                let alertController = UIAlertController(title: "Error", message: "Your e-mail address or password incorrect. Please check your information and try again. ", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    

}
