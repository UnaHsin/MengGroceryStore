//
//  ConfigSingleton.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import Foundation

class ConfigSingleton {
    static let SERVER_URL = "http://192.168.1.15:8080/"
    
    //MARK: - api url
    // 商品資訊
    static let GET_ALL_PRODUCT_INFO_URL = SERVER_URL + "productDetail/getAll"
    // 全部廠商資訊
    static let GET_ALL_FIRM_INFO_URL = SERVER_URL + "firmDetail/getAll"
    // 新增廠商資訊
    static let ADD_NEW_FIRM_INFO_URL = SERVER_URL + "firmDetail/save"
    // 新增商品資訊
    static let ADD_NEW_PRODUCT_INFO_URL = SERVER_URL + "productDetail/save"
}

