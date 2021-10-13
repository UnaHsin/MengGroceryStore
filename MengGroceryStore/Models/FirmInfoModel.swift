//
//  FirmInformationModel.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/14.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

struct FirmInfoModel: Codable {
    var rcode: String?
    var rtMsg: String?
    
    var firmId: Int?
    var firmName: String?
    var firmContactPerson: String?
    var firmContactNumber: String?
    var firmVatNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case rcode = "rcode"
        case rtMsg = "rtMsg"
        
        case firmId = "firmId"
        case firmName = "firmName"
        case firmContactPerson = "firmContactPerson"
        case firmContactNumber = "firmContactNumber"
        case firmVatNumber = "firmVatNumber"
    }
}
