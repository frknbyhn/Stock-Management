//
//  ChooseProductViewController.swift
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

class ChooseProductViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, HomeRefresherDelegate, UISearchBarDelegate{
    
    var stock = [Products]()
    var filteredStock = [Products]()

    var comingCustomerID : String = ""
    var comingCustomerSales : String = ""
    var uid = Auth.auth().currentUser?.uid

    func refreshNeed(needed: Bool) {
        if needed{
            stock.removeAll()
            webReq()
            productsTableView.reloadData()
        }
    }
    
    

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var productsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webReq()
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = .orange
        
        self.productsTableView.register(UINib(nibName: "ProductsTableViewCell", bundle: nil), forCellReuseIdentifier: "productCell")
        productsTableView.delegate = self
        productsTableView.dataSource = self
        self.productsTableView.reloadData()
        
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
                stock.productID = snap.key
                self.stock.append(stock)
                self.productsTableView.reloadData()
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
            productsTableView?.reloadData()
        }
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredStock = stock.filter({( searchData : Products) -> Bool in
            return (searchData.productName.lowercased().contains(searchText.lowercased()))
        })
        productsTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.view.endEditing(true)
        productsTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        productsTableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "makeSaleView") as! MakeSaleViewController
        
        if searchBar.text != ""{
            vc.comingProductID = self.filteredStock[indexPath.row].productID
        }else{
         vc.comingProductID = self.stock[indexPath.row].productID
        }
        vc.comingCustomerID = comingCustomerID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 450
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  searchBar.text == "" {
            return stock.count
        } else {
            return filteredStock.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = productsTableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductsTableViewCell
        
        if searchBar.text == "" {
            cell.productNameLabel.text = stock[indexPath.row].productName
            cell.productDescLable.text = stock[indexPath.row].productDesc
            cell.stockLabel.text = String(stock[indexPath.row].productQuantity)
            cell.productImageView.kf.setImage(with: URL(string: stock[indexPath.row].productImage))
            cell.productPrice.text = stock[indexPath.row].productPrice
            cell.layer.cornerRadius = 4
        }
        else {
            cell.productNameLabel.text = filteredStock[indexPath.row].productName
            cell.productDescLable.text = filteredStock[indexPath.row].productDesc
            cell.stockLabel.text = String(filteredStock[indexPath.row].productQuantity)
            cell.productImageView.kf.setImage(with: URL(string: filteredStock[indexPath.row].productImage))
            cell.productPrice.text = filteredStock[indexPath.row].productPrice
            cell.layer.cornerRadius = 4
        }
        
        return cell
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
