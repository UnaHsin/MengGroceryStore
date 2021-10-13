//
//  ConfigSingleton.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

class ConfigSingleton {
    //static let SERVER_URL = "http://10.200.2.167:8080/"
//    static let SERVER_URL = "http://192.168.1.15:8080/"
    static let SERVER_URL = "http://ec2-13-229-90-27.ap-southeast-1.compute.amazonaws.com:8080/storedb/"
    
    //MARK: - api url
    // 商品資訊
    static let GET_ALL_PRODUCT_INFO_URL = SERVER_URL + "productDetail/getAll"
    // 進貨廠商資訊+庫存量
    static let GET_PRODUCT_FIRM_INVENTORY_INFO_URL = SERVER_URL + "purchaseDetail/findFirmData"
    // 全部廠商資訊
    static let GET_ALL_FIRM_INFO_URL = SERVER_URL + "firmDetail/getAll"
    // 新增廠商資訊
    static let ADD_NEW_FIRM_INFO_URL = SERVER_URL + "firmDetail/save"
    // 新增商品資訊
    static let ADD_NEW_PRODUCT_INFO_URL = SERVER_URL + "productDetail/save"
    // 用Barcode搜尋商品資訊
    static let GET_PRODUCT_INFO_BY_BARCODE_URL = SERVER_URL + "productDetail/queryByBarcode"
    // 用Barcode搜尋進貨廠商資訊
    static let GET_FIRM_INFO_BY_BARCODE_URL = SERVER_URL + "purchaseDetail/findFirmIdAndName"
    // 新增進貨明細
    static let ADD_NEW_PURCHASE_ITEM_URL = SERVER_URL + "purchaseInfo/save"
    // 查詢進貨歷史明細
    static let GET_PURCHASE_HISTORY_LIST_URL = SERVER_URL + "purchaseInfo/getAll"
    // 查詢單筆進貨資料
    static let GET_PURCHASE_SINGLE_INFO_URL = SERVER_URL + "purchaseDetail/getById"
    // 查詢庫存資料
    static let GET_INVENTORY_INFO_LIST_URL = SERVER_URL + "inventoryInfo/findAll"
    
    //MARK: - view name
    static let HOME_VIEW_NAEM = "ViewController"
    static let PRODUCT_INFO_LIST_VIEW_NAME = "ProdustInfoListView"
    static let ADD_NEW_PRODUCT_INTO_VIEW_NAME = "AddNewProductInfoView"
    static let PURCASH_HISTORY_LIST_VIEW_NAME = "PurchaseHistoryListView"
    static let PURCHASE_INFO_LIST_VIEW_NAME = "PurchaseInfoNewListView"
    static let PURCHASE_PRODUCT_INFO_VIEW_NAME = "PurchaseProductInfoView"
    static let SCAN_QR_CODE_VIEW_NAME = "ScanQRCodeView"
    static let INVENTORY_INFO_VIEW_NAME = "InventoryInfoView"
    static let SHOPPING_CAR_INFO_VIEW_NAME = "ShoppingCarView"
}



