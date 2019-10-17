//
//  ProductUpdateModel.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/26.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class ProductUpdateModel: NSObject {
    var barCode: String?
    var productName: String?
    var price: Int?
    var expireDate: String?
    var remainedQuantity: Int?
    var restockQuantity: Int?
    var salesQuantity: Int?
    var totalQuantity: Int?
    
    override init() {
        
    }
    
    init(barCode: String, productName: String, price: Int?, expireDate: String?, remainedQuantity: Int?, restockQuantity: Int?, salesQuantity: Int?, totalQuantity: Int?) {
        self.barCode = barCode
        self.productName = productName
        self.price = price
        self.expireDate = expireDate
        self.remainedQuantity = remainedQuantity
        self.restockQuantity = restockQuantity
        self.salesQuantity = salesQuantity
        self.totalQuantity = totalQuantity
    }
    
    init(barCode: String, productName: String) {
        self.barCode = barCode
        self.productName = productName
    }
}
