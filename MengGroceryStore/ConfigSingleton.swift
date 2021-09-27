//
//  ConfigSingleton.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

class ConfigSingleton {
    static let SERVER_URL = "http://10.200.2.167:8080/"
    
    //MARK: - api url
    // 商品資訊
    static let GET_ALL_PRODUCT_INFO_URL = SERVER_URL + "productDetail/getAll"
    // 全部廠商資訊
    static let GET_ALL_FIRM_INFO_URL = SERVER_URL + "firmDetail/getAll"
    // 新增廠商資訊
    static let ADD_NEW_FIRM_INFO_URL = SERVER_URL + "firmDetail/save"
    // 新增商品資訊
    static let ADD_NEW_PRODUCT_INFO_URL = SERVER_URL + "productDetail/save"
    // 用Barcode搜尋商品資訊
    static let GET_PRODUCT_INFO_BY_BARCODE_URL = SERVER_URL + "productDetail/queryByBarcode"
    
    //MARK: - view name
    static let HOME_VIEW_NAEM = "ViewController"
    static let ADD_NEW_PRODUCT_INTO_VIEW_NAME = "AddNewProductInfoView"
    static let PURCHASE_INFO_LIST_VIEW_NAME = "PurchaseInfoListView"
    static let PURCHASE_PRODUCT_INFO_VIEW_NAME = "PurchaseProductInfoView"
    static let SCAN_QR_CODE_VIEW_NAME = "ScanQRCodeView"
}



