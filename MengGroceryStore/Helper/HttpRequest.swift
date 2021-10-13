//
//  HttpRequest.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HttpRequest {
    
    static let share = HttpRequest()
    
    typealias DoneHandler = (_ result: Any?, _ error: Error?) -> Void
    
    //MARK: - api
    func getAllProductInfoApi(completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_ALL_PRODUCT_INFO_URL, parameters: nil, completion: completion)
    }
    
    func getAllFirmInfoApi(completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_ALL_FIRM_INFO_URL, parameters: nil, completion: completion)
    }
    
    func addNewFirmInfoApi(_ parameters: [String : Any], completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.ADD_NEW_FIRM_INFO_URL, parameters: parameters, completion: completion)
    }
    
    func addNewProductInfoApi(_ parameters: [String : Any], completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.ADD_NEW_PRODUCT_INFO_URL, parameters: parameters, completion: completion)
    }
    
    func getProductInfoByBarcodeApi(_ parameters: [String : Any], completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_PRODUCT_INFO_BY_BARCODE_URL, parameters: parameters, completion: completion)
    }
    
    func getFirmInventoryInfoByBarcodeApi(_ parameters: [String : Any], completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_PRODUCT_FIRM_INVENTORY_INFO_URL, parameters: parameters, completion: completion)
    }
    
    func addNewPurchaseItemApi(_ parameters: [[String: Any]], completion: @escaping DoneHandler) {
        doPostJsonArray(urlStr: ConfigSingleton.ADD_NEW_PURCHASE_ITEM_URL, parametersList: parameters, completion: completion)
    }
    
    func getPurchaseHistoryListApi(completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_PURCHASE_HISTORY_LIST_URL, parameters: nil, completion: completion)
    }
    
    func getPurchaseSingleInfoApi(_ parameters: [String: Any], completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_PURCHASE_SINGLE_INFO_URL, parameters: parameters, completion: completion)
    }
    
    func getInventoryInfoListApi(completion: @escaping DoneHandler) {
        doPostJSON(urlStr: ConfigSingleton.GET_INVENTORY_INFO_LIST_URL, parameters: nil, completion: completion)
    }
    
    //MARK:  - GET and POST func
    fileprivate func doGetJSON(urlStr: String, parameters: [String : Any]?, completion: @escaping DoneHandler) {
        print("get url: \(urlStr)")
        AF.request(urlStr, method: .get, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            self.handleJSON(response: response, completion: completion)
        }
    }
    
    fileprivate func doPostJSON(urlStr: String, parameters: [String : Any]?, completion: @escaping DoneHandler) {
        print("par: \(parameters)")
        
        AF.request(urlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            
            self.handleJSON(response: response, completion: completion)
        }
    }
    
    fileprivate func doPostJsonArray(urlStr: String, parametersList: [[String: Any]], completion: @escaping DoneHandler) {
        
        let url = URL(string: urlStr)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: parametersList, options: [])
        AF.request(request).responseJSON { (response) in

            self.handleJSON(response: response, completion: completion)
        }
    }
    
    private func handleJSON(response: AFDataResponse<Any>, completion: DoneHandler) {
        print("handleJSON response: \(response)")
    
        switch response.result {
        case .success(let json):
            //sslErrTimes = 0
            if let finalJson = json as? [String: Any] {
                print("[String: Any]")
                completion(finalJson, nil)
                return
            }
            
            if let finalJsonArray = json as? [[String: Any]] {
                print("[[String: Any]]")
                completion(finalJsonArray, nil)
                return
            }
            
            let error = NSError(domain: "Invalid JSON object.", code:-1, userInfo: nil)
            completion(nil, error)

        case .failure(let error):
            print("Server respond error: \(error._code)")
            completion(nil, error)
        }
    }
    
}
