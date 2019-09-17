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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func cellSetup() {
        postView.layer.cornerRadius = 20
    }
}
