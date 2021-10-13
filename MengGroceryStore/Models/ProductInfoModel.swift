//
//  ProductInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct ProductInfoModel: Codable {
    var rcode: String?
    var rtMsg: String?
    
    var productId: Int?
    var productBarcode: String?
    var productName: String?
    var productPrice: Int?
    var firmName: String?
    var inventoryAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case productId = "productId"
        case productBarcode = "productBarcode"
        case productName = "productName"
        case productPrice = "productPrice"
        case firmName = "firmName"
        case inventoryAmount = "inventoryTot"
    }
}
