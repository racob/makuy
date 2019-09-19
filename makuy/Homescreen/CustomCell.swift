//
//  CustomCell.swift
//  makuy
//
//  Created by Eibiel Sardjanto on 17/09/19.
//  Copyright © 2019 Eibiel Sardjanto. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var numOfPeople: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var host: UILabel!
    @IBOutlet weak var price: UILabel!
    
    var joined = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellViewSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func cellViewSetup() {
        postView.layer.cornerRadius = 20
        category.layer.cornerRadius = 5
        host.layer.cornerRadius = 5
    }
}
