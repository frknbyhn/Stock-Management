//
//  CustomersViewController.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher
import FirebaseAuth

class CustomersViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate, HomeRefresherDelegate, UISearchBarDelegate{
    
    func refreshNeed(needed: Bool) {
        if needed{
            stock.removeAll()
            webReq()
        }
    }

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var customerTableView: UITableView!
    
    var stock = [Customers]()
    var filteredStock = [Customers]()
    var uid = Auth.auth().currentUser?.uid

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webReq()
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .orange
        
        self.customerTableView.register(UINib(nibName: "CustomersTableViewCell", bundle: nil), forCellReuseIdentifier: "customerCell")
        customerTableView.delegate = self
        customerTableView.dataSource = self
        self.customerTableView.reloadData()

    }
    
    func webReq(){
        let stockRef = Database.database().reference().child(uid!).child("Customers")
        stockRef.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let stockDict = snap.value as! [String:Any]
                let stock = Customers()
                stock.customerAddress = (stockDict["customerAddress"] as? String)!
                stock.customerName = (stockDict["customerName"] as? String)!
                stock.customerOwner = (stockDict["customerOwner"] as? String)!
                stock.customerPhone = (stockDict["customerPhone"] as? String)!
                stock.customerPurchaseQuantity = (stockDict["customerPurchaseQuantity"] as? Int)!
                stock.customerID = snap.key
                self.filteredStock.append(stock)
                self.stock.append(stock)
                self.customerTableView.reloadData()
            }
            if self.stock.count == 0 {
                let alert : UIAlertController = UIAlertController(title: "Stock Management", message: "It seems you haven't any add customer\nPlease add customer", preferredStyle: .alert)
                let okay : UIAlertAction = UIAlertAction(title: "Add Customer", style: .default) { (action) in
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "customerAddView") as! AddCustomerViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let denied = UIAlertAction(title: "Dissmis", style: .cancel) { (action) in
                    self.popToRoot()
                }
                alert.addAction(okay)
                alert.addAction(denied)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchBar.text != "") {
            filterContentForSearchText(searchBar.text!)
        } else {
            customerTableView?.reloadData()
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStock = stock.filter({( searchData : Customers) -> Bool in
            return (searchData.customerName.lowercased().contains(searchText.lowercased()))
        })
        customerTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        customerTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        customerTableView.reloadData()
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
        if editingStyle == .delete{
            print("Deleted")
            
            let stockRef = Database.database().reference().child(uid!).child("Customers").child(stock[indexPath.row].customerID)
            stockRef.removeValue()
            self.stock.remove(at: indexPath.row)
            self.customerTableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 237
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchBar.text == "" {
            return stock.count
        } else {
            return filteredStock.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = customerTableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomersTableViewCell
        
        if searchBar.text == "" {
            cell.addressLabel.text = stock[indexPath.row].customerAddress
            cell.customerNameLabel.text = stock[indexPath.row].customerName
            cell.ownerLabel.text = stock[indexPath.row].customerOwner
            cell.phoneLabel.text = stock[indexPath.row].customerPhone
            cell.toCustomerButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        }else{
            cell.addressLabel.text = filteredStock[indexPath.row].customerAddress
            cell.customerNameLabel.text = filteredStock[indexPath.row].customerName
            cell.ownerLabel.text = filteredStock[indexPath.row].customerOwner
            cell.phoneLabel.text = filteredStock[indexPath.row].customerPhone
            cell.toCustomerButton.addTarget(self, action: #selector(buttonClicked), for: UIControl.Event.touchUpInside)
        }
        return cell
    }
    
    @objc func buttonClicked(sender: UIButton!){
        
        let point = sender.convert(CGPoint.zero, to: customerTableView as UIView)
        let indexPath : IndexPath! = customerTableView.indexPathForRow(at: point)
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "goToCustomerView") as! ToCustomerMapViewController
        if searchBar.text == ""{
            vc.comingCustomerID = self.stock[indexPath.row].customerID
            vc.comingCustomerName = self.stock[indexPath.row].customerName
            vc.comingCustomerOwner = self.stock[indexPath.row].customerOwner
        }else{
            vc.comingCustomerID = self.filteredStock[indexPath.row].customerID
            vc.comingCustomerName = self.filteredStock[indexPath.row].customerName
            vc.comingCustomerOwner = self.filteredStock[indexPath.row].customerOwner
        }
        self.present(vc, animated: true, completion: nil)
        
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "customerAddView")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
}
