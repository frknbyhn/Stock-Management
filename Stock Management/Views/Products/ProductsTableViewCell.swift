//
//  ProductsTableViewCell.swift
//  Stock Management
//
//  Created by Furkan Beyhan on 21.03.2019.
//  Copyright © 2019 Furkan Beyhan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Kingfisher

class ProductsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDescLable: UITextView!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

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
