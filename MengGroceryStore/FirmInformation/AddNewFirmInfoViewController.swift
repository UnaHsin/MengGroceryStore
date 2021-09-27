//
//  AddFirmInfoViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/16.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class AddNewFirmInfoViewController: BaseViewController {
    private let vwScrollview = UIScrollView()
    private let mainView = UIView()
    private let firmNameText = UITextField()
    private let firmContactPersonText = UITextField()
    private let firmContactNumberText = UITextField()
    private let firmVatNumberText = UITextField()
    
    private var keyboardHeightLayoutConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "新增廠商資料"
        
        // 頁面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //偵測鍵盤移動
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name:  UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // app進入背景時，關閉鍵盤
        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard), name: UIApplication.willResignActiveNotification, object: nil)
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
        
        // 廠商名稱 提示
        let firmNameTipLab = UILabel()
        firmNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmNameTipLab.text = "廠商名稱"
        mainView.addSubview(firmNameTipLab)
        firmNameTipLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
        }
        
        // 廠商名稱 輸入欄位
        firmNameText.borderStyle = .roundedRect
        firmNameText.returnKeyType = .done
        firmNameText.font = textFont
        mainView.addSubview(firmNameText)
        firmNameText.snp.makeConstraints { make in
            make.top.equalTo(firmNameTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
            make.height.equalTo(txtH)
        }
        
        // 廠商統一編號 提示
        let firmVatNumberTextTipLab = UILabel()
        firmVatNumberTextTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmVatNumberTextTipLab.text = "廠商統一編號"
        mainView.addSubview(firmVatNumberTextTipLab)
        firmVatNumberTextTipLab.snp.makeConstraints { make in
            make.top.equalTo(firmNameText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(firmNameTipLab.snp.width)
        }
        
        // 廠商統一編號 輸入欄位
        firmVatNumberText.borderStyle = .roundedRect
        firmVatNumberText.returnKeyType = .done
        firmVatNumberText.font = textFont
        firmVatNumberText.keyboardType = .numberPad
        mainView.addSubview(firmVatNumberText)
        firmVatNumberText.snp.makeConstraints { make in
            make.top.equalTo(firmVatNumberTextTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
            make.height.equalTo(txtH)
        }
        
        // 廠商聯絡人 提示
        let firmContactPersonTipLab = UILabel()
        firmContactPersonTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmContactPersonTipLab.text = "廠商聯絡人"
        mainView.addSubview(firmContactPersonTipLab)
        firmContactPersonTipLab.snp.makeConstraints { make in
            make.top.equalTo(firmVatNumberText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(firmNameTipLab.snp.width)
        }
        
        // 廠商聯絡人 輸入欄位
        firmContactPersonText.borderStyle = .roundedRect
        firmContactPersonText.returnKeyType = .done
        firmContactPersonText.font = textFont
        mainView.addSubview(firmContactPersonText)
        firmContactPersonText.snp.makeConstraints { make in
            make.top.equalTo(firmContactPersonTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
            make.height.equalTo(txtH)
        }
        
        // 廠商聯絡電話 提示
        let firmContactNumberTipLab = UILabel()
        firmContactNumberTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmContactNumberTipLab.text = "廠商聯絡電話"
        mainView.addSubview(firmContactNumberTipLab)
        firmContactNumberTipLab.snp.makeConstraints { make in
            make.top.equalTo(firmContactPersonText.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalTo(firmNameTipLab.snp.width)
        }
        
        // 廠商聯絡人 輸入欄位
        firmContactNumberText.borderStyle = .roundedRect
        firmContactNumberText.returnKeyType = .done
        firmContactNumberText.font = textFont
        firmContactNumberText.keyboardType = .numberPad
        mainView.addSubview(firmContactNumberText)
        firmContactNumberText.snp.makeConstraints { make in
            make.top.equalTo(firmContactNumberTipLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40 * deviceScale)
            make.height.equalTo(txtH)
        }
        
        // 送出資料 按鈕
        let addFirmInfoBtn = UIButton(type: .custom)
        addFirmInfoBtn.layer.cornerRadius = 7
        addFirmInfoBtn.backgroundColor = .systemBlue
        addFirmInfoBtn.setTitle("新增廠商", for: .normal)
        addFirmInfoBtn.setTitleColor(.white, for: .normal)
        addFirmInfoBtn.titleLabel?.font = textFont
        addFirmInfoBtn.addTarget(self, action: #selector(addFirmInfoBtnPressed(_:)), for: .touchUpInside)
        mainView.addSubview(addFirmInfoBtn)
        addFirmInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(firmContactNumberText.snp.bottom).offset(40 * deviceScale)
            make.centerX.equalTo(mainView)
            make.width.equalTo(firmContactNumberText.snp.width).multipliedBy(0.6)
            make.height.equalTo(addFirmInfoBtn.snp.width).multipliedBy(0.25)
        }
        
        mainView.snp.makeConstraints { make in
            make.bottom.equalTo(addFirmInfoBtn.snp.bottom).offset(30)
        }
    }
    
    //MARK: - @objc func
    @objc private func hideKeyboard() {
        firmNameText.resignFirstResponder()
        firmContactPersonText.resignFirstResponder()
        firmContactNumberText.resignFirstResponder()
        firmVatNumberText.resignFirstResponder()
    }
    
    @objc private func addFirmInfoBtnPressed(_ sender: UIButton) {
        commonFunc.showLoading(showMsg: "Loading...")
        
        let firmNameStr = firmNameText.text ?? ""
        let firmVatNumberStr = firmVatNumberText.text ?? ""
        let firmContactPersonStr = firmContactPersonText.text ?? ""
        let firmContactNumberStr = firmContactNumberText.text ?? ""
        
        // 送出新廠商資訊
        sendNewFirmInfo(firmNameStr, firmVatNumberStr, firmContactPersonStr, firmContactNumberStr)
        
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
    private func sendNewFirmInfo(_ firmName: String, _ firmVatNumber: String, _ firmContactPerson: String, _ firmContactNumber: String) {
        
        var parameters: [String : Any] = [:]
        parameters["firmName"] = firmName
        parameters["firmVatNumber"] = firmVatNumber
        parameters["firmContactPerson"] = firmContactPerson
        parameters["firmContactNumber"] = firmContactNumber
        
        httpRequest.addNewFirmInfoApi(parameters) { result, error in
            let funcName = "addNewFirmInfoApi"
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
            print("addNewFirmInfoApi result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode(FirmInfoModel.self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            if let rcode = resultObject.rcode {
                if "0000".elementsEqual(rcode) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
