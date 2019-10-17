//
//  ProductListTableViewCell.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class ProductListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var barCodeLab: UILabel!
    @IBOutlet weak var productNameLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
