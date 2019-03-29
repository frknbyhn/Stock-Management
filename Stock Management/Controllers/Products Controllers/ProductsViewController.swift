//
//  ProductsViewController.swift
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

class ProductsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, HomeRefresherDelegate, UISearchBarDelegate {
    
    var uid = Auth.auth().currentUser?.uid

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    func refreshNeed(needed: Bool) {
        if needed {
            stock.removeAll()
            viewDidLoad()
        }
    }

    @IBOutlet weak var productsTableView: UITableView!
    
    
    var stock = [Products]()
    var filteredStock = [Products]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
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
                self.stock.append(stock)
                self.filteredStock.append(stock)
                self.productsTableView.reloadData()
                stock.productID = snap.key
            }
            if self.stock.count == 0 {
                let alert : UIAlertController = UIAlertController(title: "Stock Management", message: "There is no product in your stocks.\nPlease add some product.", preferredStyle: .alert)
                let okay : UIAlertAction = UIAlertAction(title: "Add Product", style: .default) { (action) in
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "addProductView") as! AddProductsToStockViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                let denied = UIAlertAction(title: "Dismiss", style: .cancel) { (action) in
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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
                print("Deleted")
                let stockRef = Database.database().reference().child(uid!).child("Products").child(stock[indexPath.row].productID)
                stockRef.removeValue()
                self.stock.remove(at: indexPath.row)
                self.productsTableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addExistProductView") as! AddExistProductViewController
        navigationController?.pushViewController(vc, animated: true)
        
        if searchBar.text != "" {
            vc.productID = filteredStock[indexPath.row].productID
        }else{
            vc.productID = stock[indexPath.row].productID
        }
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
    
    @IBAction func addButtonClicked(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "addProductView") as! AddProductsToStockViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
