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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "新增商品"
        
        // 頁面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 取得廠商資料
        getFirmInfoList()
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
        productBarcodeText.font = textFont
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
        
        
        
        mainView.snp.makeConstraints { make in
            make.bottom.equalTo(firmText.snp.bottom).offset(30)
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
}
