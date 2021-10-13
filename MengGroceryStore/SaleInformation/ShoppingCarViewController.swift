//
//  ShoppingCarViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/13.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ShoppingCarViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    //view
    private var mTV: UITableView!
    private let mainView = UIView()
    private let editInfoMainView = UIView()
    private let editInfoView = UIView()
    private let editAmountLab = UILabel()
    private let editAmountText = UITextField()
    private let editPriceText = UITextField()
    private let finalPurchaseInfoView = UIView()
    private let finalPurchaseItemNoLab = UILabel()
    private let finalPurchasePriceLab = UILabel()
    private let tvCellName = "ShoppingCarTableCell"
    private let line = UIView()
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    private var isShowView = false
    private var editBarcode = ""
    
    // data
    private var purchaseProductList = [ProductInfoModel]()
    var carProductList = [ShoppingCarInfoModel]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "購物車"

        //畫面初始化
        viewInit()
        
        // 表單ui初始化
        tableViewInit()
        
        // 修改資訊畫面
        editInfoViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if carProductList.count > 0 {
            print("carList: \(carProductList)")
            mTV.reloadData()
            
            // 最下方顯示總價資訊
            showFinalInfo()
        }
        
    }
    
    private func viewInit() {
        deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
        // 左上返回鍵
        let backButton = UIBarButtonItem(title: "< 返回",
                                         style: .done,
                                         target: self,
                                         action: #selector(goBack(_:)))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoScanView(_:)))
        
        
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        let bFont = UIFont.systemFont(ofSize: 15 * deviceScale)
        
        let nameItemLab = UILabel()
        nameItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        nameItemLab.text = "商品名稱"
        mainView.addSubview(nameItemLab)
        nameItemLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        let numberItemLab = UILabel()
        numberItemLab.labInit(textColor: .systemBlue, textPlace: .center, font: aFont)
        numberItemLab.text = "數量"
        mainView.addSubview(numberItemLab)
        numberItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(nameItemLab)
            make.left.equalTo(nameItemLab.snp.right).offset(5)
            make.width.equalToSuperview().multipliedBy(0.13)
        }
        
        let priceItemLab = UILabel()
        priceItemLab.labInit(textColor: .systemBlue, textPlace: .center, font: aFont)
        priceItemLab.text = "價錢"
        mainView.addSubview(priceItemLab)
        priceItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(nameItemLab)
            make.right.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        //分隔線設定
        line.backgroundColor = .lightGray
        mainView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(nameItemLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.5)
            make.width.equalToSuperview().offset(-20)
        }
        
        finalPurchaseInfoView.backgroundColor = Colors.lightGaryColor
        mainView.addSubview(finalPurchaseInfoView)
        finalPurchaseInfoView.snp.makeConstraints { make in
            make.right.left.bottom.equalToSuperview()
            
        }
        
        // 進貨項目總數量 大包
        let finalPurchaseItemNoStack = UIStackView()
        finalPurchaseItemNoStack.spacing = 5
        finalPurchaseItemNoStack.distribution = .fillProportionally
        finalPurchaseItemNoStack.axis = .vertical
        finalPurchaseInfoView.addSubview(finalPurchaseItemNoStack)
        finalPurchaseItemNoStack.snp.makeConstraints { make in
            make.bottom.equalTo(mainView.safeArea.bottom)
            make.left.equalToSuperview().offset(15 * deviceScale)
            make.width.equalToSuperview().multipliedBy(0.2)
        }

        let finalPurchaseItemNoTipLab = UILabel()
        finalPurchaseItemNoTipLab.labInit(textColor: .black, textPlace: .center, font: bFont)
        finalPurchaseItemNoTipLab.text = "購買項目"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoTipLab)
        
        finalPurchaseItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        finalPurchaseItemNoLab.text = "計算中"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoLab)
        
        let btnFont = UIFont.systemFont(ofSize: 10 * deviceScale)
        let sendShoppingOrderInfoBtn = UIButton(type: .custom)
        sendShoppingOrderInfoBtn.layer.cornerRadius = 7
        sendShoppingOrderInfoBtn.backgroundColor = .systemBlue
        sendShoppingOrderInfoBtn.setTitle("結帳", for: .normal)
        sendShoppingOrderInfoBtn.setTitleColor(.white, for: .normal)
        sendShoppingOrderInfoBtn.titleLabel?.font = btnFont
        sendShoppingOrderInfoBtn.titleLabel?.lineBreakMode = .byWordWrapping
        sendShoppingOrderInfoBtn.addTarget(self, action: #selector(sendShoppingOrderInfoBtnPressed(_:)), for: .touchUpInside)
        finalPurchaseInfoView.addSubview(sendShoppingOrderInfoBtn)
        sendShoppingOrderInfoBtn.snp.makeConstraints { make in
            make.centerY.equalTo(finalPurchaseItemNoStack)
            make.right.equalToSuperview().offset(-15 * deviceScale)
            make.width.equalTo(finalPurchaseItemNoTipLab).multipliedBy(0.6)
            make.height.equalTo(finalPurchaseItemNoStack.snp.height)
        }
        
        // 進貨總價 大包
        let finalPurchasePriceStack = UIStackView()
        finalPurchasePriceStack.spacing = 5
        finalPurchasePriceStack.distribution = .fillProportionally
        finalPurchasePriceStack.axis = .vertical
        finalPurchaseInfoView.addSubview(finalPurchasePriceStack)
        finalPurchasePriceStack.snp.makeConstraints { make in
            make.centerY.equalTo(finalPurchaseItemNoStack)
            make.left.equalTo(finalPurchaseItemNoStack.snp.right).offset(15 * deviceScale)
            make.right.equalTo(sendShoppingOrderInfoBtn.snp.left).offset(-15 * deviceScale)
        }
        
        let finalPurchasePriceTipLab = UILabel()
        finalPurchasePriceTipLab.labInit(textColor: .black, textPlace: .center, font: bFont)
        finalPurchasePriceTipLab.text = "進貨總價"
        finalPurchasePriceStack.addArrangedSubview(finalPurchasePriceTipLab)
        
        finalPurchasePriceLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        finalPurchasePriceLab.text = "計算中"
        finalPurchasePriceStack.addArrangedSubview(finalPurchasePriceLab)
        
        finalPurchaseInfoView.snp.makeConstraints { make in
            make.top.equalTo(finalPurchaseItemNoStack.snp.top).offset(-10 * deviceScale)
        }
        
    }
    
    private func tableViewInit() {
        //生成 UITableView
        mTV = UITableView(frame: .zero, style: .plain)
        mTV.estimatedRowHeight = 44 * deviceScale
        mTV.rowHeight = UITableView.automaticDimension
        mTV.delegate = self
        mTV.dataSource = self
        mTV.separatorColor = .black
        //mTV.translatesAutoresizingMaskIntoConstraints = false
        mTV.register(ShoppinCarTableViewCell.self, forCellReuseIdentifier: tvCellName)
        mainView.addSubview(mTV)
        mTV.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(finalPurchaseInfoView.snp.top).offset(-5 * deviceScale)
            make.left.right.equalToSuperview()
        }
    }
    
    private func editInfoViewInit() {
        editInfoMainView.backgroundColor = Colors.masklightGaryColor
        mainView.addSubview(editInfoMainView)
        editInfoMainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        editInfoView.backgroundColor = Colors.mainColor
        editInfoView.layer.cornerRadius = 8
        editInfoMainView.addSubview(editInfoView)
        editInfoView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.3)
        }
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        let textFont = UIFont.systemFont(ofSize: 20 * deviceScale)
        let editTipLab = UILabel()
        editTipLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        editTipLab.text = "修改資訊"
        editInfoView.addSubview(editTipLab)
        editTipLab.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        let editAmountTipLab = UILabel()
        editAmountTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        editAmountTipLab.text = "修改數量: "
        editInfoView.addSubview(editAmountTipLab)
        editAmountTipLab.snp.makeConstraints { make in
            make.top.equalTo(editTipLab).offset(30 * deviceScale)
            make.left.equalToSuperview().offset(15 * deviceScale)
        }
        
        let addBtn = UIButton(type: .custom)
        addBtn.layer.cornerRadius = 7
        addBtn.backgroundColor = .systemBlue
        addBtn.setTitle("+", for: .normal)
        addBtn.setTitleColor(.white, for: .normal)
        addBtn.titleLabel?.font = aFont
        addBtn.titleLabel?.lineBreakMode = .byWordWrapping
        addBtn.addTarget(self, action: #selector(addBtnPressed(_:)), for: .touchUpInside)
        editInfoView.addSubview(addBtn)
        addBtn.snp.makeConstraints { make in
            make.centerY.equalTo(editAmountTipLab)
            make.left.equalTo(editAmountTipLab.snp.right).offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalTo(addBtn.snp.width)
        }
        
        editAmountLab.labInit(textColor: .black, textPlace: .center, font: textFont)
        editInfoView.addSubview(editAmountLab)
        editAmountLab.snp.makeConstraints { make in
            make.centerY.equalTo(editAmountTipLab)
            make.left.equalTo(addBtn.snp.right).offset(10)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(editAmountTipLab)
        }
        
        let reduceBtn = UIButton(type: .custom)
        reduceBtn.layer.cornerRadius = 7
        reduceBtn.backgroundColor = .systemBlue
        reduceBtn.setTitle("-", for: .normal)
        reduceBtn.setTitleColor(.white, for: .normal)
        reduceBtn.titleLabel?.font = aFont
        reduceBtn.titleLabel?.lineBreakMode = .byWordWrapping
        reduceBtn.addTarget(self, action: #selector(reduceBtnPressed(_:)), for: .touchUpInside)
        editInfoView.addSubview(reduceBtn)
        reduceBtn.snp.makeConstraints { make in
            make.centerY.equalTo(editAmountTipLab)
            make.left.equalTo(editAmountLab.snp.right).offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
            make.height.equalTo(reduceBtn.snp.width)
        }
        
//        editAmountText.borderStyle = .roundedRect
//        editAmountText.returnKeyType = .done
//        editAmountText.font = textFont
//        editPriceText.keyboardType = .numberPad
//        editInfoView.addSubview(editAmountText)
//        editAmountText.snp.makeConstraints { make in
//            make.centerY.equalTo(editAmountTipLab)
//            make.left.equalTo(editAmountTipLab.snp.right).offset(10)
//            make.width.equalToSuperview().multipliedBy(0.5)
//            make.height.equalTo(editAmountTipLab)
//        }
        
        let editPriceTipLab = UILabel()
        editPriceTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        editPriceTipLab.text = "修改價錢: "
        editInfoView.addSubview(editPriceTipLab)
        editPriceTipLab.snp.makeConstraints { make in
            make.top.equalTo(editAmountTipLab.snp.bottom).offset(20 * deviceScale)
            make.left.equalTo(editAmountTipLab)
        }
        
        editPriceText.borderStyle = .roundedRect
        editPriceText.returnKeyType = .done
        editPriceText.font = textFont
        editPriceText.keyboardType = .numberPad
        editInfoView.addSubview(editPriceText)
        editPriceText.snp.makeConstraints { make in
            make.centerY.equalTo(editPriceTipLab)
            make.left.equalTo(editPriceTipLab.snp.right).offset(10)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(editPriceTipLab)
        }
        
       let editDownBtn = UIButton()
        editDownBtn.layer.cornerRadius = 7
        editDownBtn.backgroundColor = .systemBlue
        editDownBtn.setTitle("確定", for: .normal)
        editDownBtn.setTitleColor(.white, for: .normal)
        editDownBtn.titleLabel?.font = aFont
        editDownBtn.titleLabel?.lineBreakMode = .byWordWrapping
        editDownBtn.addTarget(self, action: #selector(editDownBtnPressed(_:)), for: .touchUpInside)
        editInfoView.addSubview(editDownBtn)
        editDownBtn.snp.makeConstraints { make in
            make.top.equalTo(editPriceText.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalToSuperview().multipliedBy(0.13)
        }
        
        // 隱藏修改畫面
        isShowEditView(false)
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return carProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTV.dequeueReusableCell(withIdentifier: tvCellName) as! ShoppinCarTableViewCell
        
        
        let item = carProductList[indexPath.row]
        print("itemInfo: \(item)")
        cell.productnameStr = item.productName
        cell.productItemAmountStr = "\(item.saleAmount ?? 0)"
        cell.productAllPriceStr = "\(item.salePrice ?? 0)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell 的選取狀態
        mTV.deselectRow(at: indexPath, animated: true)
        
        
        var productItem = carProductList[indexPath.row]
        editBarcode = productItem.productBarcode!
        editPriceText.text = "\(productItem.salePrice!)"
        editAmountLab.text = "\(productItem.saleAmount!)"
        
        isShowEditView(true)
        
        //        //轉跳
        //        let controller = storyboard!.instantiateViewController(withIdentifier: "ProductInformationView") as! ProductInformationViewController
        //        //controller.
//        navigationController!.pushViewController(controller, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 移除資料
        carProductList.remove(at: indexPath.row)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }
    
    //MARK: - func
    private func showFinalInfo() {
        var finalPrice = 0
        for item in carProductList {
            finalPrice += item.salePrice!
        }
        
        finalPurchaseItemNoLab.text = "\(carProductList.count) 項"
        finalPurchasePriceLab.text = "\(finalPrice) 元"
    }
    
    private func isShowEditView(_ isShow: Bool) {
        editInfoMainView.isHidden = !isShow
    }
    
    private func hideKeyboard() {
        editAmountText.resignFirstResponder()
        editPriceText.resignFirstResponder()
        
        editInfoMainView.endEditing(true)
    }

    //MARK: - @objc func
    @objc private func goBack(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.HOME_VIEW_NAEM)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoScanView(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ScanSoppingCarView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func addBtnPressed (_ sender: UIButton) {
        let amountStr = editAmountLab.text
        var amountInt = Int(amountStr ?? "0")
        var priceInt = 0
        
        amountInt? += 1
        
        if amountInt != nil {
            carProductList.forEach { item in
                if item.productBarcode == editBarcode {
                    // 更新單項總價
                    priceInt = amountInt! * item.productPrice!
                }
            }
            
            editAmountLab.text = "\(amountInt ?? 0)"
            editPriceText.text = "\(priceInt)"
        }
    }
    
    @objc private func reduceBtnPressed(_ sender: UIButton) {
        let amountStr = editAmountLab.text
        var amountInt = Int(amountStr ?? "0")
        var priceInt = 0
        
        if amountInt != 0 {
            amountInt? -= 1
        }
        
        if amountInt != nil {
            carProductList.forEach { item in
                if item.productBarcode == editBarcode {
                    // 更新單項總價
                    priceInt = amountInt! * item.productPrice!
                }
            }
            
            editAmountLab.text = "\(amountInt ?? 0)"
            editPriceText.text = "\(priceInt)"
        }
    }
    
    @objc private func editDownBtnPressed (_ sender: UIButton) {
        let newAmountStr = editAmountLab.text
        let newPriceStr = editPriceText.text
        var newAmountInt = Int(newAmountStr ?? "0")
        var newPriceInt = Int(newPriceStr ?? "0")
        
        for (index, item) in carProductList.enumerated() {
            //print("位置 \(index): 產品 \(item)")
            if item.productBarcode == editBarcode {
                print("item name: \(item.productName), amount: \(newAmountInt)")
                if newAmountInt == nil || newPriceInt == nil {
                    newAmountInt = 0
                    newPriceInt = 0
                    
                    // 數值為nil時，砍掉那個item
                    carProductList.remove(at: index)
                } else {
                
                // 新的item
                let nowInfoProduct = ShoppingCarInfoModel(rcode: nil, rtMsg: nil, productId: item.productId, productBarcode: editBarcode, productName: item.productName, productPrice: item.productPrice, saleAmount: newAmountInt, salePrice: newPriceInt)
                
                // 取代原本item
                carProductList[index] = nowInfoProduct
                }
                
            }
        }
        
        // 清空資訊
        editBarcode = ""
        editAmountLab.text = ""
        editPriceText.text = ""
        
        // 收鍵盤
        hideKeyboard()
        
        // 更新最後資訊
        showFinalInfo()
        
        mTV.reloadData()
        
        isShowEditView(false)
    }

    @objc private func sendShoppingOrderInfoBtnPressed (_ sender: UIButton) {
        
    }
    
    
}
