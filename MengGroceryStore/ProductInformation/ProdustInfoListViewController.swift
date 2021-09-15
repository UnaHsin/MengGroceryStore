//
//  ProdustInfoListViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ProdustInfoListViewController: UIViewController {

    private let httpRequest = HttpRequest.share
    private let commonFunc = CommonFunc.share
    
    private var productInfoList = [ProductInfoModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "商品列表"

        viewInit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 取得商品資訊
        getAllProductInfoList()
    }
    
    func viewInit() {
        
        
        
    }

    
    //MARK: - func
    private func getAllProductInfoList() {
        httpRequest.getAllProductInfo { result, error in
            let funcName = "getAllProductInfo"
            if let error = error {
                print("\(funcName) Info is error: \(error)")
                self.commonFunc.closeLoading()
                print("-----Err 到這----")
                return
            }
            
            guard let result = result else {
                print("\(funcName) Info is nil")
                self.commonFunc.closeLoading()
                return
            }
            
            self.commonFunc.closeLoading()
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
            
            self.productInfoList = resultObject
            tableView.reloadData()
        }
    }

}
