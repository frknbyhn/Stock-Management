//
//  FirstPageViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseAuth

class FirstPageViewController: BaseViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true

        loginButton.clipsToBounds = true
        loginButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        loginButton.alpha = 1
        loginButton.setTitleColor(.white, for: UIControl.State.normal)
        loginButton.layer.cornerRadius = 20
        
        registerButton.clipsToBounds = true
        registerButton.layer.cornerRadius = 20
        registerButton.backgroundColor = UIColor(displayP3Red: 0.54, green: 0.54, blue: 1.00, alpha: 1)
        registerButton.alpha = 1
        registerButton.setTitleColor(.white, for: UIControl.State.normal)
        
        if Auth.auth().currentUser != nil {
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mainPage")
            let ncncnc = UINavigationController(rootViewController: vc)
            ncncnc.isNavigationBarHidden = true
            self.present(ncncnc, animated: true, completion: nil)
        }
    }

    @IBAction func loginButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginPage") as! LogInViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func registerButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "registerPage") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
