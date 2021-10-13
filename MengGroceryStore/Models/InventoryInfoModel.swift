//
//  InventoryInfoModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/10.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct InventoryInfoModel: Codable {
    var rcode: String?
    var rtMsg: String?
    
    var inventoryId: Int?
    var productId: Int?
    var productBarcode: String?
    var productName: String?
    var inventoryAmount: Int?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case inventoryId = "inventoryId"
        case productId = "productId"
        case productBarcode = "productBarcode"
        case productName = "productName"
        case inventoryAmount = "invettoryTot"
    }
}
