//
//  BaseViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 22.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseAuth

class BaseViewController: UIViewController {
    
    var customerStock = [Customers]()
    var productStock = [Products]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func popToRoot(){
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
}
