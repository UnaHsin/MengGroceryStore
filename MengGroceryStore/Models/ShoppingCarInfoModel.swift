//
//  ShoppingCarInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/13.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct ShoppingCarInfoModel: Codable {
    var rcode: String?
    var rtMsg: String?
    
    var productId: Int?
    var productBarcode: String?
    var productName: String?
    var productPrice: Int?
    var saleAmount: Int?
    var salePrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case productId = "productId"
        case productBarcode = "productBarcode"
        case productName = "productName"
        case productPrice = "productPrice"
        case saleAmount = "salesQuantity"
        case salePrice = "salesTotamt"
    }
}
