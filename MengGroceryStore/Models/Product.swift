//
//  Product.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class Product: NSObject {
    var barCode: String?
    var productName: String?
    var price: String?
    var expireDate: String?
    var remainedQuantity: String?
    var restockQuantity: String?
    var salesQuantity: String?
    var totalQuantity: String?
    var simpleSalesQuantity: String?
    
    override init() {
        
    }
    
    init(barCode: String, productName: String, price: String?, expireDate: String?, remainedQuantity: String?, restockQuantity: String?, salesQuantity: String?, totalQuantity: String?) {
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
    
    init(barCode: String, productName: String, price: String, simpleSalesQuantity: String) {
        self.barCode = barCode
        self.productName = productName
        self.price = price
        self.simpleSalesQuantity = simpleSalesQuantity
    }
    
}
