//
//  ProductInformationViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/10.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import CoreImage

class ProductInformationViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // 從上一頁接的參數
    var productItem = ProductInfoModel()
    
    // view
    private let vwScrollview = UIScrollView()
    private let mainView = UIView()
    private let editView = UIView()
    private let productNameText = UITextField()
    private let salePriceText = UITextField()
    private let stockAmountLab = UILabel()
    private let editBtn = UIButton(type: .custom)
    private var firmCollectionView: UICollectionView!
    
    private var keyboardHeightLayoutConstraint: Constraint?
    
    private let firmCellName = "FirmCellName"
    private var isEdit = false
    private var productBarcodeStr = ""
    private var prodcutNameStr = ""
    private var salePriceInt = 0
    
    // db中的廠商資訊(from server)
    private var firmList = [ProductInfoModel]()
    //private var firmList = ["7-11", "全家", "萊爾富", "OK便利商店"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "商品資訊"

        // 取得商品資訊
        getProductInfo()
        
        // 畫面初始化
        viewInit()
        
        // 取得進貨廠商資料
        getFirmInfo()
    }
    
    //MARK: - view init
    private func viewInit() {
        // 取得螢幕資訊
        var deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
        let screenWidth = SystemInfo.getScreenWidth()
        let screenHeight = SystemInfo.getScreenHeight()
        
        //let topBarHeight = SystemInfo.getStatusBarHeight()
        //let navigationHeigh = topBarHeight + (self.navigationController?.navigationBar.frame.height ?? 0.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editProductInfo(_:)))
        
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
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        let textFont = UIFont.systemFont(ofSize: 20 * deviceScale)
        let txtH = 35 * deviceScale
        
        let barcodeImgView = UIImageView()
        if let barcodeImg = generateBarcode(message: productBarcodeStr) {
            barcodeImgView.image = barcodeImg
            mainView.addSubview(barcodeImgView)
            barcodeImgView.snp.makeConstraints { make in
                make.top.equalTo(mainView.snp.top).offset(15 * deviceScale)
                make.centerX.equalTo(mainView)
                make.width.equalTo(mainView.snp.width).multipliedBy(0.5)
                make.height.equalTo(barcodeImgView.snp.width).multipliedBy(0.4)
            }
        }
        
        let barcodeLab = UILabel()
        barcodeLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        barcodeLab.text = productBarcodeStr
        mainView.addSubview(barcodeLab)
        barcodeLab.snp.makeConstraints { make in
            make.top.equalTo(barcodeImgView.snp.bottom)
            make.centerX.equalTo(mainView)
            make.width.equalTo(barcodeImgView)
        }
        
        let productNameTipLab = UILabel()
        productNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productNameTipLab.text = "商品名稱"
        mainView.addSubview(productNameTipLab)
        productNameTipLab.snp.makeConstraints { make in
            make.top.equalTo(barcodeLab.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalTo(mainView)
            make.width.equalTo(mainView).offset(-40 * deviceScale)
        }
        
        productNameText.borderStyle = .roundedRect
        productNameText.returnKeyType = .done
        productNameText.font = textFont
        productNameText.text = productItem.productName
        mainView.addSubview(productNameText)
        productNameText.snp.makeConstraints { make in
            make.top.equalTo(productNameTipLab.snp.bottom).offset(8)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
            make.height.equalTo(txtH)
        }
        
        let salePriceTipLab = UILabel()
        salePriceTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        salePriceTipLab.text = "商品售價"
        mainView.addSubview(salePriceTipLab)
        salePriceTipLab.snp.makeConstraints { make in
            make.top.equalTo(productNameText.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
        }
        
        salePriceText.borderStyle = .roundedRect
        salePriceText.returnKeyType = .done
        salePriceText.font = textFont
        salePriceText.text = "\(productItem.productPrice ?? 0)"
        mainView.addSubview(salePriceText)
        salePriceText.snp.makeConstraints { make in
            make.top.equalTo(salePriceTipLab.snp.bottom).offset(8)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
            make.height.equalTo(txtH)
        }
        
        let stockTipLab = UILabel()
        stockTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        stockTipLab.text = "庫存量"
        mainView.addSubview(stockTipLab)
        stockTipLab.snp.makeConstraints { make in
            make.top.equalTo(salePriceText.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
        }
        
        stockAmountLab.labInit(textColor: .black, textPlace: .left, font: textFont)
        mainView.addSubview(stockAmountLab)
        stockAmountLab.snp.makeConstraints { make in
            make.top.equalTo(stockTipLab.snp.bottom)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
            make.height.equalTo(txtH)
        }
        
        let firmListTipLab = UILabel()
        firmListTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmListTipLab.text = "進貨廠商"
        mainView.addSubview(firmListTipLab)
        firmListTipLab.snp.makeConstraints { make in
            make.top.equalTo(stockAmountLab.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
        }
        
        // collection view cell 大小設定
        let firmlayout = UICollectionViewCenterLayout()
        firmlayout.estimatedItemSize = CGSize(width: 140, height: 40)
        // collection view 基本設定
        firmCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight), collectionViewLayout: firmlayout)
        firmCollectionView.backgroundColor = .white
        firmCollectionView.delegate = self
        firmCollectionView.dataSource = self
        mainView.addSubview(firmCollectionView)
        firmCollectionView.snp.makeConstraints { make in
            make.top.equalTo(firmListTipLab.snp.bottom).offset(10)
            make.centerX.equalTo(productNameTipLab)
            make.width.equalTo(productNameTipLab)
            make.height.equalToSuperview().multipliedBy(0.1)
        }
        
        editBtn.layer.cornerRadius = 7
        editBtn.backgroundColor = .systemBlue
        editBtn.setTitle("完成修改", for: .normal)
        editBtn.setTitleColor(.white, for: .normal)
        editBtn.titleLabel?.font = textFont
        editBtn.addTarget(self, action: #selector(editBtnPressed(_:)), for: .touchUpInside)
        mainView.addSubview(editBtn)
        editBtn.snp.makeConstraints { make in
            make.top.equalTo(firmCollectionView.snp.bottom).offset(30 * deviceScale)
            make.centerX.equalTo(mainView)
            make.width.equalTo(barcodeImgView.snp.width)
            make.height.equalTo(editBtn.snp.width).multipliedBy(0.22)
        }
        editBtn.isHidden = true

        mainView.snp.makeConstraints { make in
            make.bottom.equalTo(editBtn.snp.bottom).offset(30)
        }
        
        mainView.addSubview(editView)
        editView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(stockAmountLab.snp.bottom).offset(30)
        }
        
        //設置數據
        setupBtnController()
    }
    
    //MARK: - UICollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return firmList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = firmList[indexPath.item]
        if let inventoryAmount = item.inventoryAmount {
            stockAmountLab.text = "\(inventoryAmount)"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: firmCellName, for: indexPath) as! ProductInfoCollectionViewCell
        cell.titleStr = item.firmName
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
//        if isEdit {
//            let firmItem = firmList[indexPath.item]
//            selectDelectFirmInfo(firmItem)
//        }
    }

    //MARK: - func
    private func generateBarcode(message: String?) -> UIImage? {
        
        let inputData = message?.data(using: .utf8, allowLossyConversion: false)
        
        // CICode128BarcodeGenerator
        let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
        filter.setValue(inputData, forKey: "inputMessage")
        
        let ciImage = filter.outputImage!
        let returnImage = UIImage(ciImage: ciImage)
        
        return returnImage
    }
    
    private func getProductInfo() {
        productBarcodeStr = productItem.productBarcode ?? ""
        prodcutNameStr = productItem.productName ?? ""
        salePriceInt = productItem.productPrice ?? 0
    }
    
    func setupBtnController() {
        firmCollectionView.register(ProductInfoCollectionViewCell.self, forCellWithReuseIdentifier: firmCellName)
        
        firmCollectionView.reloadData()
    }
    
    func selectDelectFirmInfo(_ indexItem: String) {
        //let alertMessage = firmList[indexItem]
        showAlertCustomizeBtnWithAction(okBtnTitle: "確定", noBtnTitle: "取消", message: "將 \(indexItem) 商家資訊刪除") { action in
            
        }
    }
    
    //MARK: - api func
    private func getFirmInfo() {
        commonFunc.showLoading(showMsg: "Loading...")
        var par: [String : Any] = [:]
        par["productBarcode"] = productBarcodeStr
        
        httpRequest.getFirmInventoryInfoByBarcodeApi(par) { result, error in
            let funcName = "getPurchaseHistoryListAip"
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
            print("getPurchaseHistoryList result: \(result)")
            
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
            self.firmList = resultObject
            self.firmCollectionView.reloadData()
        }
    }
    
    //MARK: - @objc func
    @objc private func hideKeyboard() {
        productNameText.resignFirstResponder()
        salePriceText.resignFirstResponder()
    }
    
    @objc private func editProductInfo(_ sender: UIBarButtonItem) {
        editView.isHidden = true
        editBtn.isHidden = false
        
        isEdit = true
    }
    
    @objc private func editBtnPressed(_ sender: UIButton) {
        
        isEdit = false
    }
}
