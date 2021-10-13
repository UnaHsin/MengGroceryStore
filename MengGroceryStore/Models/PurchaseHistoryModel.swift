//
//  PurchaseHistoryModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/1.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct PurchaseHistoryModel: Codable {
    var rcode: String?
    var rtMsg: String?
    
    var purchaseSn: Int?
    var purchaseId: String?
    var purchaseTime: String?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case purchaseSn = "purchaseSn"
        case purchaseId = "purchaseId"
        case purchaseTime = "purchaseTime"
    }
}
