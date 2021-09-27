//
//  PurchaseProductInfoViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/24.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class PurchaseProductInfoViewController: BaseViewController, UITextFieldDelegate {
    
    // view
    private let vwScrollview = UIScrollView()
    private let mainView = UIView()
    private let productNameText = UITextField()
    private let productBarcodeText = UITextField()
    private let purchaseAmountText = UITextField()
    private let purchasePriceText = UITextField()
    private let firmText = UITextField()
    
    //顯示錯誤訊息資訊
    private let errProductNameLab = UILabel()
    private let errProductBarcodeLab = UILabel()
    private let errPurchaseAmountLab = UILabel()
    private let errPurchasePriceLab = UILabel()
    private let errFirmLab = UILabel()
    
    private var keyboardHeightLayoutConstraint: Constraint?
    
    private var firmList = [FirmInfoModel]()
    private var productName = ""
    
    var barcodeNumber = ""
    var purchaseList = [PurchaseInfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "進貨商品"

        // 畫面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //偵測鍵盤移動
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // app進入背景時，關閉鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIApplication.willResignActiveNotification, object: nil)
        
        // from 掃QRcode頁面
        productBarcodeText.text = barcodeNumber
        
        if barcodeNumber.count > 0 {
            // 取得商品資訊
            getProductName()
            
            // 取得廠商資訊
            getFirmInfoList()
        }
        
        
    }
    
    //MARK: - view init
    private func viewInit() {
        // 取得螢幕資訊
        var deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
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
        let errFont = UIFont.systemFont(ofSize: 17 * deviceScale)
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
        productBarcodeText.tag = 0
        productBarcodeText.delegate = self
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
        
        // 商品條碼 錯誤提示
        errProductBarcodeLab.labInit(textColor: .red, textPlace: .left, font: errFont)
        //errProductBarcodeLab.text = "產品條碼有誤"
        mainView.addSubview(errProductBarcodeLab)
        errProductBarcodeLab.snp.makeConstraints { make in
            make.top.equalTo(productBarcodeText.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 商品名稱 提示
        let productNameTipLab = UILabel()
        productNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productNameTipLab.text = "商品名稱"
        mainView.addSubview(productNameTipLab)
        productNameTipLab.snp.makeConstraints { make in
            make.top.equalTo(errProductBarcodeLab.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 商品名稱 輸入欄位
        productNameText.borderStyle = .roundedRect
        productNameText.returnKeyType = .done
        productNameText.font = barcodeFont
        productNameText.isUserInteractionEnabled = false
        productNameText.tag = 1
        productNameText.delegate = self
        mainView.addSubview(productNameText)
        productNameText.snp.makeConstraints { make in
            make.top.equalTo(productNameTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
            make.height.equalTo(txtH)
        }
        
        // 商品名稱 錯誤提示
        errProductNameLab.labInit(textColor: .red, textPlace: .left, font: errFont)
        //errProductNameLab.text = "產品商品有誤"
        mainView.addSubview(errProductNameLab)
        errProductNameLab.snp.makeConstraints { make in
            make.top.equalTo(productNameText.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 進貨價錢 提示
        let productSalePriceTipLab = UILabel()
        productSalePriceTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productSalePriceTipLab.text = "進貨價錢"
        mainView.addSubview(productSalePriceTipLab)
        productSalePriceTipLab.snp.makeConstraints { make in
            make.top.equalTo(errProductNameLab.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 進貨價錢 輸入欄位
        purchasePriceText.borderStyle = .roundedRect
        purchasePriceText.returnKeyType = .done
        purchasePriceText.font = textFont
        purchasePriceText.keyboardType = .numberPad
        purchasePriceText.tag = 2
        purchasePriceText.delegate = self
        mainView.addSubview(purchasePriceText)
        purchasePriceText.snp.makeConstraints { make in
            make.top.equalTo(productSalePriceTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
            make.height.equalTo(txtH)
        }
        
        // 商品進貨價錢 錯誤提示
        errPurchasePriceLab.labInit(textColor: .red, textPlace: .left, font: errFont)
        //errPurchasePriceLab.text = "產品進貨價錢有誤"
        mainView.addSubview(errPurchasePriceLab)
        errPurchasePriceLab.snp.makeConstraints { make in
            make.top.equalTo(purchasePriceText.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 進貨數量 提示
        let purchaseAmountTipLab = UILabel()
        purchaseAmountTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        purchaseAmountTipLab.text = "進貨數量"
        mainView.addSubview(purchaseAmountTipLab)
        purchaseAmountTipLab.snp.makeConstraints { make in
            make.top.equalTo(errPurchasePriceLab.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 進貨數量 輸入欄位
        purchaseAmountText.borderStyle = .roundedRect
        purchaseAmountText.returnKeyType = .done
        purchaseAmountText.font = textFont
        purchaseAmountText.keyboardType = .numberPad
        purchaseAmountText.tag = 3
        purchaseAmountText.delegate = self
        mainView.addSubview(purchaseAmountText)
        purchaseAmountText.snp.makeConstraints { make in
            make.top.equalTo(purchaseAmountTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
            make.height.equalTo(txtH)
        }
        
        // 進貨數量 錯誤顯示
        errPurchaseAmountLab.labInit(textColor: .red, textPlace: .left, font: errFont)
        mainView.addSubview(errPurchaseAmountLab)
        errPurchaseAmountLab.snp.makeConstraints { make in
            make.top.equalTo(purchaseAmountText.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 進貨廠商名稱 提示
        let firmNameTipLab = UILabel()
        firmNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmNameTipLab.text = "進貨廠商"
        mainView.addSubview(firmNameTipLab)
        firmNameTipLab.snp.makeConstraints { make in
            make.top.equalTo(errPurchaseAmountLab.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 進貨廠商 輸入欄位
        firmText.borderStyle = .roundedRect
        firmText.isUserInteractionEnabled = false
        firmText.font = textFont
        firmText.tag = 4
        firmText.delegate = self
        mainView.addSubview(firmText)
        firmText.snp.makeConstraints { make in
            make.top.equalTo(firmNameTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab.snp.width)
        }
        
        // 進貨廠商選單 Btn
        let showFirmListBtn = UIButton()
        showFirmListBtn.layer.cornerRadius = 7
        showFirmListBtn.backgroundColor = .clear
        showFirmListBtn.addTarget(self, action: #selector(showFirmList(_:)), for: .touchUpInside)
        mainView.addSubview(showFirmListBtn)
        showFirmListBtn.snp.makeConstraints { make in
            make.top.bottom.left.right.equalTo(firmText)
        }
        
        // 進貨廠商 錯誤提示
        errFirmLab.labInit(textColor: .red, textPlace: .left, font: errFont)
        //errFirmLab.text = "進貨廠商名稱有誤"
        mainView.addSubview(errFirmLab)
        errFirmLab.snp.makeConstraints { make in
            make.top.equalTo(firmText.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalTo(productBarcodeTipLab)
        }
        
        // 送出資料 按鈕
        let sendProductInfoBtn = UIButton(type: .custom)
        sendProductInfoBtn.layer.cornerRadius = 7
        sendProductInfoBtn.backgroundColor = .systemBlue
        sendProductInfoBtn.setTitle("新增進貨商品", for: .normal)
        sendProductInfoBtn.setTitleColor(.white, for: .normal)
        sendProductInfoBtn.titleLabel?.font = textFont
        sendProductInfoBtn.addTarget(self, action: #selector(sendProductInfoBtnPressed(_:)), for: .touchUpInside)
        mainView.addSubview(sendProductInfoBtn)
        sendProductInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(errFirmLab.snp.bottom).offset(40 * deviceScale)
            make.centerX.equalTo(mainView)
            make.width.equalTo(firmText.snp.width).multipliedBy(0.6)
            make.height.equalTo(sendProductInfoBtn.snp.width).multipliedBy(0.25)
        }
        
        mainView.snp.makeConstraints { make in
            make.bottom.equalTo(sendProductInfoBtn.snp.bottom).offset(30)
        }

    }
    
    //MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            switch textField.tag {
            case 0:
                // 清除錯誤訊息
                if !"".elementsEqual(errProductBarcodeLab.text ?? "") {
                    if text.count > 0 {
                        errProductBarcodeLab.text = ""
                    }
                }
                
            case 1:
                // 清除錯誤訊息
                if !"".elementsEqual(errProductNameLab.text ?? "") {
                    if text.count > 0 {
                        errProductNameLab.text = ""
                    }
                }
                
            case 2:
                // 清除錯誤訊息
                if !"".elementsEqual(errPurchasePriceLab.text ?? "") {
                    if text.count > 0 {
                        errPurchasePriceLab.text = ""
                    }
                }
                
            case 3:
                // 清除錯誤訊息
                if !"".elementsEqual(errPurchaseAmountLab.text ?? "") {
                    if text.count > 0 {
                        errPurchaseAmountLab.text = ""
                    }
                }
                
            case 4:
                // 清除錯誤訊息
                if !"".elementsEqual(errFirmLab.text ?? "") {
                    if text.count > 0 {
                        errFirmLab.text = ""
                    }
                }
            default:
                break
            }
        }
        
        return true
    }
    
    // 鍵盤 右下角
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let returnType = textField.returnKeyType
        
        // 點 鍵盤上的done 關閉鍵盤
        if returnType == .done {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    //MARK: - Api func
    private func getFirmInfoList() {
        //commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getAllFirmInfoApi { result, error in
            let funcName = "getFirmInfoList"
            if let error = error {
                print("\(funcName) Info is error: \(error)")
                //self.commonFunc.closeLoading()
                print("-----Err 到這----")
                return
            }
            
            guard let result = result else {
                print("\(funcName) Info is nil")
                //self.commonFunc.closeLoading()
                return
            }
            
            //self.commonFunc.closeLoading()
            print("getFirmInfoList result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([FirmInfoModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.firmList = resultObject
        }
    }
    
    private func getProductName() {
        commonFunc.showLoading(showMsg: "載入商品名稱")
        
        var parameters: [String : Any] = [:]
        parameters["productBarcode"] = barcodeNumber
        
        httpRequest.getProductInfoByBarcodeApi(parameters) { result, error in
            let funcName = "getProductName"
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
            guard let resultObject = try? decoder.decode(ProductInfoModel.self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            if let productNameStr = resultObject.productName {
                self.productName = productNameStr
                self.productNameText.text = self.productName
            }
        }
        
    }
    
    //MARK: - @objc func
    @objc private func hideKeyboard() {
        productBarcodeText.resignFirstResponder()
        purchaseAmountText.resignFirstResponder()
        purchasePriceText.resignFirstResponder()
        firmText.resignFirstResponder()
    }
    
    @objc private func gotoScanView(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.SCAN_QR_CODE_VIEW_NAME) as! ScanQRCodeViewController
        controller.viewNumber = 2
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @objc private func sendProductInfoBtnPressed(_ sender: UIButton) {
        
        let firmNameStr = firmText.text ?? ""
        let purchaseAmountStr = purchaseAmountText.text ?? ""
        let purchasePriceStr = purchasePriceText.text ?? ""
        let purchaseDateTimeStr = commonFunc.getDateTimeSS()
        
        var okToSend = true
        
        if barcodeNumber.count < 1 {
            errProductBarcodeLab.text = "請輸入商品條碼"
            okToSend = false
        }
        
        if purchasePriceStr.count < 1 {
            errPurchasePriceLab.text = "請輸入進貨數量"
            okToSend = false
        }
        
        if purchaseAmountStr.count < 1 {
            errPurchaseAmountLab.text = "請輸入進貨數量"
            okToSend = false
        }
        
        if firmNameStr.count < 1 {
            errFirmLab.text = "請輸入進貨廠商名稱"
            okToSend = false
        }
        
        if okToSend {
            let purchasePriceInt = Int(purchasePriceStr) ?? 0
            let purchaseAmountInt = Int(purchaseAmountStr) ?? 0
        
        let purchaseItem = PurchaseInfoModel(productName: productName, productBarcode: barcodeNumber, firmName: firmNameStr, purchaseAmount: purchaseAmountInt, purchasePrice: purchasePriceInt, purchaseDateTime: purchaseDateTimeStr)
            
            purchaseList.append(purchaseItem)
            
            let controller = storyboard!.instantiateViewController(withIdentifier: ConfigSingleton.PURCHASE_INFO_LIST_VIEW_NAME) as! PurchaseInfoListViewController
            controller.purchaseProductList = purchaseList
            navigationController!.pushViewController(controller, animated: false)
        }
        
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
}
