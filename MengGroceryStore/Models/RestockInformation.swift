//
//  RestockInformation.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/10/4.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import Foundation
import SQLite

struct RestockInformation: Codable {
    var restockDate: String    //進貨日期
    var restockAmount: Int     //進貨數量
    var expireDate: String     //進貨效期
    var inPrice: Int           //進貨價格
}
