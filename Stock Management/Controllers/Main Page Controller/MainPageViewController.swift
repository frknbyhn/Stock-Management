//
//  MainPageViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol HomeRefresherDelegate : class {
    func refreshNeed(needed: Bool)
}

class MainPageViewController: BaseViewController {
    
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var customerButton: UIButton!
    @IBOutlet weak var makeSaleButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    @IBAction func mapButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "mapView") as! MapViewController
        let ncncnc = UINavigationController(rootViewController: vc)
        ncncnc.isNavigationBarHidden = true
        self.present(ncncnc, animated: true, completion: nil)
    }
    
    @IBAction func makeSaleButton(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "chooseCustomerView") as! ChooseCustomerViewController
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func customerButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "customersView") as! CustomersViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func productsButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "productsView") as! ProductsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logOutButtonClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
