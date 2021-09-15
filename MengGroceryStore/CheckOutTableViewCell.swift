//
//  CheckOutTableViewCell.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/11/14.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class CheckOutTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productNameLab: UILabel!
    @IBOutlet weak var simpleSalesQuantityLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
