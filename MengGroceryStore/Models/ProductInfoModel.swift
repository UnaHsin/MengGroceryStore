//
//  ProductInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct ProductInfoModel: Codable {
    var productBarcode: String?
    var productName: String?
    var productPrice: Int?
    
    enum CodingKeys: String, CodingKey {
        case productBarcode = "productBarcode"
        case productName = "productName"
        case productPrice = "productPrice"
    }
}
