//
//  CustomersTableViewCell.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class CustomersTableViewCell: UITableViewCell {

    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var toCustomerButton: UIButton!
    
    var stock = [Customers]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        toCustomerButton.clipsToBounds = true
        toCustomerButton.layer.cornerRadius = 4
        toCustomerButton.backgroundColor = UIColor(displayP3Red: 1.00, green: 0.40, blue: 0.00, alpha: 1)
        toCustomerButton.alpha = 1
        toCustomerButton.setTitleColor(.white, for: UIControl.State.normal)
        
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor(displayP3Red: 0.68, green: 0.68, blue: 0.68, alpha: 0.71).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowOpacity = 0.71
        self.layer.shadowRadius = 0.0
        self.clipsToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }    
}
