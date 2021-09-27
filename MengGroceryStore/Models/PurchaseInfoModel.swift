//
//  PurchaseInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/23.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct PurchaseInfoModel: Codable {
    var productName: String
    var productBarcode: String
    var firmName: String
    var purchaseAmount: Int
    var purchasePrice: Int
    var purchaseDateTime: String
    
    
}
