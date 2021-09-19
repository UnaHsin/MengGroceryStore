//
//  AddNewProductInfoViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/14.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class AddNewProductInfoViewController: UIViewController {
    
    private let vwScrollview = UIScrollView()
    private let mainView = UIView()
    private let productBarcodeText = UITextField()
    private let productNameText = UITextField()
    private let productSalePriceText = UITextField()
    private let firmText = UITextField()
    
    private var keyboardHeightLayoutConstraint: Constraint?
    
    private let httpRequest = HttpRequest.share
    private let commonFunc = CommonFunc.share
    
    private var firmList = [FirmInformationModel]()
    
    var barcodeNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "新增商品"
        
        // 頁面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //偵測鍵盤移動
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // app進入背景時，關閉鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIApplication.willResignActiveNotification, object: nil)
        
        productBarcodeText.text = barcodeNumber
        
        // 取得廠商資料
        getFirmInfoList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //移除監聽器
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - view init
    private func viewInit() {
        // 取得螢幕資訊
        var deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
        // 左上返回鍵
        let backButton = UIBarButtonItem(title: "< 返回",
                                         style: .done,
                                         target: self,
                                         action: #selector(goBack(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
        vwScrollview.backgroundColor = .white
        view.addSubview(vwScrollview)
        vwScrollview.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.left.right.equalToSuperview()
            
            keyboardHeightLayoutConstraint = make.bottom.equalTo(view).constraint
        }
        keyboardHeightLayoutConstraint?.activate()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        
        // prevents the scroll view from swallowing up the touch event of child buttons
        tapGesture.cancelsTouchesInView = false
        vwScrollview.addGestureRecognizer(tapGesture)
        
        vwScrollview.addSubview(mainView)
        mainView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(vwScrollview)
        }
        
        let barcodeFont = UIFont.systemFont(ofSize: 19 * deviceScale)
        let aFont = UIFont.systemFont(ofSize: 20 * deviceScale)
        let textFont = UIFont.systemFont(ofSize: 25 * deviceScale)
        let txtH = 40 * deviceScale
            
        // 商品條碼 提示
        let productBarcodeTipLab = UILabel()
        productBarcodeTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productBarcodeTipLab.text = "商品條碼"
        mainView.addSubview(productBarcodeTipLab)
        productBarcodeTipLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
        }
        
        // 商品條碼 輸入欄位
        productBarcodeText.borderStyle = .roundedRect
        productBarcodeText.returnKeyType = .done
        productBarcodeText.font = barcodeFont
        productBarcodeText.keyboardType = .numberPad
        mainView.addSubview(productBarcodeText)
        productBarcodeText.snp.makeConstraints { make in
            make.top.equalTo(productBarcodeTipLab.snp.bottom).offset(5)
            make.left.equalTo(productBarcodeTipLab.snp.left)
            make.width.equalTo(productBarcodeTipLab).multipliedBy(0.58)
            make.height.equalTo(txtH)
        }
        
        // 轉跳 掃描條碼 頁面 Btn
        let scanBarcodeBtn = UIButton(type: .custom)
        scanBarcodeBtn.layer.cornerRadius = 7
        scanBarcodeBtn.backgroundColor = Colors.yellowColor
        scanBarcodeBtn.setTitle("掃描條碼", for: .normal)
        scanBarcodeBtn.setTitleColor(.black, for: .normal)
        scanBarcodeBtn.titleLabel?.font = aFont
        scanBarcodeBtn.addTarget(self, action: #selector(gotoScanView(_:)), for: .touchUpInside)
        mainView.addSubview(scanBarcodeBtn)
        scanBarcodeBtn.snp.makeConstraints { make in
            make.left.equalTo(productBarcodeText.snp.right).offset(15)
            make.centerY.equalTo(productBarcodeText)
            make.width.equalTo(productBarcodeTipLab).multipliedBy(0.35)
            make.height.equalTo(productBarcodeText)
        }
        
        // 商品名稱 提示
        let productNameTipLab = UILabel()
        productNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productNameTipLab.text = "商品名稱"
        mainView.addSubview(productNameTipLab)
        productNameTipLab.snp.makeConstraints { make in
            make.top.equalTo(productBarcodeText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 商品名稱 輸入欄位
        productNameText.borderStyle = .roundedRect
        productNameText.returnKeyType = .done
        productNameText.font = textFont
        mainView.addSubview(productNameText)
        productNameText.snp.makeConstraints { make in
            make.top.equalTo(productNameTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
            make.height.equalTo(txtH)
        }
        
        // 商品售價 提示
        let productSalePriceTipLab = UILabel()
        productSalePriceTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productSalePriceTipLab.text = "商品售價"
        mainView.addSubview(productSalePriceTipLab)
        productSalePriceTipLab.snp.makeConstraints { make in
            make.top.equalTo(productNameText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 商品售價 輸入欄位
        productSalePriceText.borderStyle = .roundedRect
        productSalePriceText.returnKeyType = .done
        productSalePriceText.font = textFont
        productSalePriceText.keyboardType = .numberPad
        mainView.addSubview(productSalePriceText)
        productSalePriceText.snp.makeConstraints { make in
            make.top.equalTo(productSalePriceTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
            make.height.equalTo(txtH)
        }
        
        let firmNameTipLab = UILabel()
        firmNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmNameTipLab.text = "出貨廠商"
        mainView.addSubview(firmNameTipLab)
        firmNameTipLab.snp.makeConstraints { make in
            make.top.equalTo(productSalePriceText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        firmText.borderStyle = .roundedRect
        firmText.isUserInteractionEnabled = false
        firmText.font = textFont
        mainView.addSubview(firmText)
        firmText.snp.makeConstraints { make in
            make.top.equalTo(firmNameTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        let showFirmListBtn = UIButton()
        showFirmListBtn.layer.cornerRadius = 7
        showFirmListBtn.backgroundColor = .clear
        showFirmListBtn.addTarget(self, action: #selector(showFirmList(_:)), for: .touchUpInside)
        mainView.addSubview(showFirmListBtn)
        showFirmListBtn.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(firmText)
        }
        
        // 送出資料 按鈕
        let addProductInfoBtn = UIButton(type: .custom)
        addProductInfoBtn.layer.cornerRadius = 7
        addProductInfoBtn.backgroundColor = .systemBlue
        addProductInfoBtn.setTitle("新增商品", for: .normal)
        addProductInfoBtn.setTitleColor(.white, for: .normal)
        addProductInfoBtn.titleLabel?.font = textFont
        addProductInfoBtn.addTarget(self, action: #selector(addProductInfoBtnPressed(_:)), for: .touchUpInside)
        mainView.addSubview(addProductInfoBtn)
        addProductInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(firmText.snp.bottom).offset(40 * deviceScale)
            make.centerX.equalTo(mainView)
            make.width.equalTo(firmText.snp.width).multipliedBy(0.6)
            make.height.equalTo(addProductInfoBtn.snp.width).multipliedBy(0.25)
        }
        
        
        mainView.snp.makeConstraints { make in
            make.bottom.equalTo(addProductInfoBtn.snp.bottom).offset(30)
        }
        
    }

    //MARK: - @objc func
    @objc private func hideKeyboard() {
        productNameText.resignFirstResponder()
        productBarcodeText.resignFirstResponder()
        productSalePriceText.resignFirstResponder()
        firmText.resignFirstResponder()
    }
    
    @objc private func showFirmList(_ sender: UITextField) {
        let controller = UIAlertController(title: "廠商列表", message: nil, preferredStyle: .actionSheet)
        for item in firmList {
            let action = UIAlertAction(title: item.firmName ?? "", style: .default) { action in
                  print(action.title)
                self.firmText.text = action.title
               }
               controller.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }

    @objc private func gotoScanView(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeView")
        self.navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func addProductInfoBtnPressed(_ sender: UIButton) {
        commonFunc.showLoading(showMsg: "Loading...")
        
        let productBarcodeStr = productBarcodeText.text ?? ""
        let productNameStr = productNameText.text ?? ""
        let productSalePriceStr = productSalePriceText.text ?? ""
        let firmStr = firmText.text ?? ""
        var firmIdStr = ""
        
        for item in firmList {
            if let itemFirmName = item.firmName {
                if firmStr.elementsEqual(itemFirmName) {
                    if let itemFirmId = item.firmId {
                        firmIdStr = String(itemFirmId)
                    }
                }
            }
        }
        
        // 送出新商品資訊
        sendNewProductInfo(productBarcodeStr, productNameStr, productSalePriceStr, firmIdStr)
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProdustInfoListView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo,
           let value = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
           let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            //改變下約束
            self.keyboardHeightLayoutConstraint?.updateOffset(amount: -intersection.height)
            
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: UIView.AnimationOptions(rawValue: curve),
                           animations: { self.vwScrollview.layoutSubviews() },
                           completion: nil)
        }
    }
    
    //MARK: - Api func
    private func getFirmInfoList() {
        commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getAllFirmInfoApi { result, error in
            let funcName = "getFirmInfoList"
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
            print("getFirmInfoList result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([FirmInformationModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.firmList = resultObject
        }
    }
    
    private func sendNewProductInfo(_ productBarcode: String, _ productName: String, _ productSalePrice: String, _ firmId: String) {
        
        var parameters: [String : Any] = [:]
        parameters["productBarcode"] = productBarcode
        parameters["productName"] = productName
        parameters["productPrice"] = productSalePrice
        parameters["firmId"] = firmId
        
        httpRequest.addNewProductInfoApi(parameters) { result, error in
            let funcName = "addNewProductInfoApi"
            if let error = error {
                print("\(funcName) Info is error: \(error)")
                self.commonFunc.closeLoading()
                print("-----Err 到這----")
                return
            }
            
            guard let result = result else {
                print("\(funcName) Info is nil")
                self.commonFunc.closeLoading()
                print("----result is nil 到這----")
                return
            }
            
            self.commonFunc.closeLoading()
            print("\(funcName) result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode(ProductInfoModel.self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            if let rcode = resultObject.rcode {
                if "0000".elementsEqual(rcode) {
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProdustInfoListView")
                    self.navigationController!.pushViewController(controller!, animated: true)
                }
            }
        }
    }
    
    
}
