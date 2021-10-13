//
//  PurchaseHistoryListViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/1.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class PurchaseHistoryListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //view
    private var mainTV: UITableView!
    private var detailTV: UITableView!
    private let mainView = UIView()
    private let detailMainView = UIView()
    private let detailView = UIView()
    private let purchaseNumberTipLab = UILabel()
    private let finalPurchaseInfoView = UIView()
    private let finalPurchaseItemNoLab = UILabel()
    private let finalPurchasePriceLab = UILabel()
    private let tvListCellName = "PurchaseHistoryListTableCell"
    private let tvDetailCellName = "PurchaseDetailTableCell"
    private let line = UIView()
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    private var purchaseHistoryList = [PurchaseHistoryModel]()
    private var purchaseDetailInfoList = [PurchaseInfoModel]()
    private var isShowDetail = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "進貨歷史列表"

        // 主畫面初始化
        viewInit()
        
        // 表單ui初始化
        tableViewInit()
        
        // 進貨詳細資訊畫面初始化
        deatilViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 取得進貨歷史資訊
        getPurchaseHistoryListAip()
    }
    
    //MARK: - view init
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProductList(_:)))
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        let bFont = UIFont.systemFont(ofSize: 15 * deviceScale)
        
        let numberItemLab = UILabel()
        numberItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        numberItemLab.text = "No."
        mainView.addSubview(numberItemLab)
        numberItemLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        let purchaseInfoStack = UIStackView()
        purchaseInfoStack.spacing = 5
        purchaseInfoStack.distribution = .fillProportionally
        purchaseInfoStack.axis = .horizontal
        mainView.addSubview(purchaseInfoStack)
        purchaseInfoStack.snp.makeConstraints { make in
            make.centerY.equalTo(numberItemLab)
            make.left.equalTo(numberItemLab.snp.right).offset(15 * deviceScale)
            make.right.equalToSuperview().offset(-10)
        }
        
        let purchaseNumberLab = UILabel()
        purchaseNumberLab.labInit(textColor: .systemBlue, textPlace: .center, font: aFont)
        purchaseNumberLab.text = "進貨單號"
        purchaseInfoStack.addArrangedSubview(purchaseNumberLab)
        
        let purchaseTimeLab = UILabel()
        purchaseTimeLab.labInit(textColor: .systemBlue, textPlace: .center, font: aFont)
        purchaseTimeLab.text = "進貨時間"
        purchaseInfoStack.addArrangedSubview(purchaseTimeLab)
        
        //分隔線設定
        line.backgroundColor = .lightGray
        mainView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(purchaseNumberLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.5)
            make.width.equalToSuperview().offset(-20)
        }
    }
    
    private func tableViewInit() {
        //生成 UITableView
        mainTV = UITableView(frame: .zero, style: .plain)
        mainTV.estimatedRowHeight = 44 * deviceScale
        mainTV.rowHeight = UITableView.automaticDimension
        mainTV.delegate = self
        mainTV.dataSource = self
        mainTV.separatorColor = .black
        mainTV.tag = 0
        //mTV.translatesAutoresizingMaskIntoConstraints = false
        mainTV.register(PurchaseHistoryListTableViewCell.self, forCellReuseIdentifier: tvListCellName)
        mainView.addSubview(mainTV)
        mainTV.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    private func deatilViewInit() {
        detailMainView.backgroundColor = Colors.masklightGaryColor
        mainView.addSubview(detailMainView)
        detailMainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        detailView.backgroundColor = .yellow
        detailView.layer.cornerRadius = 8
        detailMainView.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.85)
        }
        
        showDetailInfoList()
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 0 {
            return purchaseHistoryList.count
        } else {
            return purchaseDetailInfoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: tvListCellName) as! PurchaseHistoryListTableViewCell
            
            let item = purchaseHistoryList[indexPath.row]
            cell.purchaseHistoryItemNoStr = "\(indexPath.row + 1)"
            cell.purchaseHistoryNumberStr = item.purchaseId
            cell.purchaseHistoryTimeStr = item.purchaseTime
            
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: tvDetailCellName) as! PurchaseDetailTableViewCell
            
            let item = purchaseDetailInfoList[indexPath.row]
            cell.purchaseDetailItemBarcodeStr = item.productBarcode
            cell.purchaseDetailItemNameStr = item.productName
            cell.purchaseDetailItemAmountStr = "\(item.purchaseAmount)"
            cell.purchaseDetailItemPriceStr = "\(item.purchasePrice)"
            cell.purchaseFirmNameStr = item.firmName
            
            // 禁止 cell 點選
            cell.selectionStyle = .none
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell 的選取狀態
        mainTV.deselectRow(at: indexPath, animated: true)
        
        if tableView.tag == 0 {
            var productItem = purchaseHistoryList[indexPath.row]
            if let purchaseId = productItem.purchaseId {
                getPurchaseSingleItemInfo(purchaseId)
            }
        }
        
        //轉跳
//        let controller = storyboard!.instantiateViewController(withIdentifier: "ProductInformationView") as! ProductInformationViewController
//        //controller.
//        navigationController!.pushViewController(controller, animated: false)
        
    }
    
    
    //MARK: - func
    private func showDetailInfoList() {
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        let bFont = UIFont.systemFont(ofSize: 15 * deviceScale)
        let spacingW = -40 * deviceScale
        
        // 先把 view 遮起來
        isShowDetailView(false)
        
        // Title
        purchaseNumberTipLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        //titleTipLab.text = "進貨單號 \(item.purchaseDetailId)"
        purchaseNumberTipLab.text = "進貨單號"
        detailView.addSubview(purchaseNumberTipLab)
        purchaseNumberTipLab.snp.makeConstraints { make in
            make.top.equalTo(detailView.snp.top).offset(10 * deviceScale)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(spacingW)
        }
        
        // 關閉資訊 按鈕
        let closeDetailMainViewBtn = UIButton(type: .custom)
        closeDetailMainViewBtn.setTitle("X", for: .normal)
        closeDetailMainViewBtn.setTitleColor(.black, for: .normal)
        closeDetailMainViewBtn.titleLabel?.font = aFont
        closeDetailMainViewBtn.addTarget(self, action: #selector(closeDetailMainViewBtnPressed(_:)), for: .touchUpInside)
        detailView.addSubview(closeDetailMainViewBtn)
        closeDetailMainViewBtn.snp.makeConstraints { make in
            make.centerY.equalTo(purchaseNumberTipLab)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(purchaseNumberTipLab).multipliedBy(0.2)
            make.height.equalTo(closeDetailMainViewBtn)
        }
        
        finalPurchaseInfoView.backgroundColor = .red
        finalPurchaseInfoView.layer.cornerRadius = 8
        detailView.addSubview(finalPurchaseInfoView)
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
            make.bottom.equalTo(finalPurchaseInfoView.snp.bottom).offset(-5)
            make.left.equalToSuperview().offset(15 * deviceScale)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        let finalPurchaseItemNoTipLab = UILabel()
        finalPurchaseItemNoTipLab.labInit(textColor: .black, textPlace: .center, font: bFont)
        finalPurchaseItemNoTipLab.text = "進貨項目"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoTipLab)
        
        finalPurchaseItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        finalPurchaseItemNoLab.text = "計算中"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoLab)
        
        // 進貨總價 大包
        let finalPurchasePriceStack = UIStackView()
        finalPurchasePriceStack.spacing = 5
        finalPurchasePriceStack.distribution = .fillProportionally
        finalPurchasePriceStack.axis = .vertical
        finalPurchaseInfoView.addSubview(finalPurchasePriceStack)
        finalPurchasePriceStack.snp.makeConstraints { make in
            make.centerY.equalTo(finalPurchaseItemNoStack)
            make.left.equalTo(finalPurchaseItemNoStack.snp.right).offset(15 * deviceScale)
            make.right.equalToSuperview().offset(-15 * deviceScale)
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
        
        //生成 UITableView
        detailTV = UITableView(frame: .zero, style: .plain)
        detailTV.backgroundColor = .white
        detailTV.estimatedRowHeight = 44 * deviceScale
        detailTV.rowHeight = UITableView.automaticDimension
        detailTV.delegate = self
        detailTV.dataSource = self
        detailTV.separatorColor = .black
        detailTV.tag = 1
        //mTV.translatesAutoresizingMaskIntoConstraints = false
        detailTV.register(PurchaseDetailTableViewCell.self, forCellReuseIdentifier: tvDetailCellName)
        detailView.addSubview(detailTV)
        detailTV.snp.makeConstraints { (make) in
            make.top.equalTo(purchaseNumberTipLab.snp.bottom).offset(10)
            make.bottom.equalTo(finalPurchaseInfoView.snp.top)
            make.left.right.equalToSuperview()
        }
    }
    
    private func isShowDetailView(_ isShow: Bool) {
        detailMainView.isHidden = !isShow
    }
    
    //MARK: - api func
    private func getPurchaseHistoryListAip() {
        commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getPurchaseHistoryListApi { result, error in
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
            guard let resultObject = try? decoder.decode([PurchaseHistoryModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.purchaseHistoryList = resultObject
            self.mainTV.reloadData()
        }
    }
    
    private func getPurchaseSingleItemInfo(_ purchaseId: String) {
        commonFunc.showLoading(showMsg: "載入資料")
        purchaseNumberTipLab.text = "單號: " + purchaseId
        isShowDetailView(true)
        
        var parameter: [String : Any] = [:]
        parameter["purchaseId"] = purchaseId
        httpRequest.getPurchaseSingleInfoApi(parameter) { result, error in
            let funcName = "getPurchaseSingleInfoApi"
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
            guard let resultObject = try? decoder.decode([PurchaseInfoModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            self.purchaseDetailInfoList = resultObject
            self.detailTV.reloadData()
            
            
            self.showFinalInfo()
        }
    }
    
    private func showFinalInfo() {
        var finalPrice = 0
        for item in purchaseDetailInfoList {
            var itemPrice = item.purchaseAmount * item.purchasePrice
            finalPrice += itemPrice
        }
        
        finalPurchaseItemNoLab.text = "\(purchaseDetailInfoList.count) 項"
        finalPurchasePriceLab.text = "\(finalPrice) 元"
    }

    //MARK: - @objc func
    @objc private func goBack(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.HOME_VIEW_NAEM)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func addNewProductList(_ sender: UIBarButtonItem) {
        // PurchaseProductInfoView
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.PURCHASE_INFO_LIST_VIEW_NAME)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func closeDetailMainViewBtnPressed(_ sender: UIButton) {
        isShowDetailView(false)
    }

}
