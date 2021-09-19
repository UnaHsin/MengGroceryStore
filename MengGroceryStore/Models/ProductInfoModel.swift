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
    
    var productBarcode: String?
    var productName: String?
    var productPrice: Int?
    var firmId: String?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case productBarcode = "productBarcode"
        case productName = "productName"
        case productPrice = "productPrice"
        case firmId = "firmId"
    }
}
