//
//  CommonFunc.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/3.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommonFunc {
    
    static let share = CommonFunc()
    let httpRequest = HttpRequest.share
    
    var purchaseProductList = [PurchaseInfoModel]()
    var productInfoList = [ProductInfoModel]()
    
    typealias DoneHandler = (_ result: Bool) -> Void
    
    //MARK: - 商品區
    func setProductInfoList(_ items: [ProductInfoModel]) {
        productInfoList = items
    }
    
    func getProductInfoList() -> [ProductInfoModel] {
        return productInfoList
    }
    
    //MARK: - 進貨區
    func setPurchaseProductList(_ item: PurchaseInfoModel) {
        purchaseProductList.append(item)
    }
    
    func getPurchaseProductList() -> [PurchaseInfoModel] {
        return purchaseProductList
    }
    
    func refreshPurchaseProductList(_ list: [PurchaseInfoModel]) {
        purchaseProductList = list
    }
    
    //MARK: - func
    func showLoading(showMsg: String) {
        SVProgressHUD.show(withStatus: showMsg)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    func closeLoading() {
        SVProgressHUD.dismiss()
    }
    
    func getItemNo(_ index: Int) -> String {
        let nowItemNo = "\(index + 1)"
        
        return nowItemNo
    }
    
    func getDateTimeSS() -> String {
        let nowTime = Date(timeIntervalSinceNow: 0)
        let formateer = DateFormatter()
        formateer.dateFormat = "yyyyMMddhhmmss"
        let dateTime = formateer.string(from: nowTime)
        
        return dateTime
    }
    
    //MARK: - http api
    func getAllProductInfoList(completion: @escaping DoneHandler) {
        showLoading(showMsg: "Loading...")
        httpRequest.getAllProductInfoApi { result, error in
            let funcName = "getAllProductInfo"
            if let error = error {
                print("\(funcName) Info is error: \(error)")
                self.closeLoading()
                print("-----Err 到這----")
                return
            }
            
            guard let result = result else {
                print("\(funcName) Info is nil")
                self.closeLoading()
                return
            }
            
            self.closeLoading()
            print("getAllProductInfoList result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([ProductInfoModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.productInfoList = resultObject
            if self.productInfoList.count > 0 {
                completion(true)
            }
            
            completion(false)
        }
    }
}

//MARK: - extension UILable
extension UILabel {
    func labInit(textColor: UIColor, textPlace: NSTextAlignment, font: UIFont) {
        self.textColor = textColor
        self.textAlignment = textPlace
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.font = font
    }
}

//MARK: - extension NSCountedSet
extension NSCountedSet {
    var occurences: [(object: Any, count: Int)] {
     return allObjects.map { ($0, count(for: $0))}
    }
    var dictionary: [AnyHashable: Int] {
     return allObjects.reduce(into: [AnyHashable: Int](), {
      guard let key = $1 as? AnyHashable else { return }
      $0[key] = count(for: key)
     })
    }
}

