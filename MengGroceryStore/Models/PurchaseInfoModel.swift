//
//  PurchaseInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/23.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct PurchaseInfoModel: Codable {
    var purchaseDetailId: Int?
    var purchaseId: String?
    
    var productId: Int
    var productName: String
    var productBarcode: String
    var firmId: Int
    var firmName: String
    var purchaseAmount: Int
    var purchasePrice: Int

    enum CodingKeys: String, CodingKey {
        case purchaseDetailId = "purchaseDetailId"
        case purchaseId = "purchaseId"
        case productId = "productId"
        case productName = "productName"
        case productBarcode = "productBarcode"
        case firmId = "firmId"
        case firmName = "firmName"
        case purchaseAmount = "purchaseQuantity"
        case purchasePrice = "purchasePrice"
        
    }
}
