//
//  PurchaseInfoListViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/23.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import SwiftyJSON

class PurchaseInfoNewListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //view
    private var mTV: UITableView!
    private let mainView = UIView()
    private let finalPurchaseInfoView = UIView()
    private let finalPurchaseItemNoLab = UILabel()
    private let finalPurchasePriceLab = UILabel()
    private let tvCellName = "PurchaseInfoNewListTableCell"
    private let line = UIView()
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    // data
    var purchaseProductList = [PurchaseInfoModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "進貨列表"

        //畫面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        purchaseProductList = commonFunc.getPurchaseProductList()
        
        if purchaseProductList.count > 0 {
            // 表單ui初始化
            tableViewInit()
            
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProductItem(_:)))
        
        
        
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
        
        let priceItemLab = UILabel()
        priceItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        priceItemLab.text = "價錢"
        mainView.addSubview(priceItemLab)
        priceItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(numberItemLab)
            make.right.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        let nameItemLab = UILabel()
        nameItemLab.labInit(textColor: .systemBlue, textPlace: .center, font: aFont)
        nameItemLab.text = "商品名稱"
        mainView.addSubview(nameItemLab)
        nameItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(numberItemLab)
            make.left.equalTo(numberItemLab.snp.right).offset(15 * deviceScale)
            make.right.equalTo(priceItemLab.snp.left).offset(-15 * deviceScale)
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
        finalPurchaseItemNoTipLab.text = "進貨項目"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoTipLab)
        
        finalPurchaseItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        finalPurchaseItemNoLab.text = "計算中"
        finalPurchaseItemNoStack.addArrangedSubview(finalPurchaseItemNoLab)
        
        let btnFont = UIFont.systemFont(ofSize: 10 * deviceScale)
        let sendPurchaseOrderInfoBtn = UIButton(type: .custom)
        sendPurchaseOrderInfoBtn.layer.cornerRadius = 7
        sendPurchaseOrderInfoBtn.backgroundColor = .systemBlue
        sendPurchaseOrderInfoBtn.setTitle("儲存\n進貨", for: .normal)
        sendPurchaseOrderInfoBtn.setTitleColor(.white, for: .normal)
        sendPurchaseOrderInfoBtn.titleLabel?.font = btnFont
        sendPurchaseOrderInfoBtn.titleLabel?.lineBreakMode = .byWordWrapping
        sendPurchaseOrderInfoBtn.addTarget(self, action: #selector(sendPurchaseOrderInfoBtnPressed(_:)), for: .touchUpInside)
        finalPurchaseInfoView.addSubview(sendPurchaseOrderInfoBtn)
        sendPurchaseOrderInfoBtn.snp.makeConstraints { make in
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
            make.right.equalTo(sendPurchaseOrderInfoBtn.snp.left).offset(-15 * deviceScale)
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
        mTV.register(PurchaseInfoTableViewCell.self, forCellReuseIdentifier: tvCellName)
        view.addSubview(mTV)
        mTV.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom)
            make.bottom.equalTo(finalPurchaseInfoView.snp.top).offset(-5 * deviceScale)
            make.left.right.equalToSuperview()
        }
    }
    
    //MARK: - func 
    private func showFinalInfo() {
        var finalPrice = 0
        for item in purchaseProductList {
            var itemPrice = item.purchaseAmount * item.purchasePrice
            finalPrice += itemPrice
        }
        
        finalPurchaseItemNoLab.text = "\(purchaseProductList.count) 項"
        finalPurchasePriceLab.text = "\(finalPrice) 元"
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return purchaseProductList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTV.dequeueReusableCell(withIdentifier: tvCellName) as! PurchaseInfoTableViewCell
        
        
        let item = purchaseProductList[indexPath.row]
        cell.productItemNoStr = "\(indexPath.row + 1)"
        cell.productnameStr = item.productName
        
        let itemAllPriceInt = item.purchaseAmount * item.purchasePrice
        cell.productAllPriceStr = "\(itemAllPriceInt)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell 的選取狀態
        mTV.deselectRow(at: indexPath, animated: true)
        
        
            var productItem = purchaseProductList[indexPath.row]
        
        //轉跳
        let controller = storyboard!.instantiateViewController(withIdentifier: "ProductInformationView") as! ProductInformationViewController
        //controller.
        navigationController!.pushViewController(controller, animated: false)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 移除資料
        purchaseProductList.remove(at: indexPath.row)
        // 更新資料
        commonFunc.refreshPurchaseProductList(purchaseProductList)
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "刪除"
    }

    
    //MARK: - @objc func
    @objc private func goBack(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.HOME_VIEW_NAEM)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func addNewProductItem(_ sender: UIBarButtonItem) {
        // PurchaseProductInfoView
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "PurchaseProductInfoView") as! PurchaseProductInfoViewController
        self.navigationController!.pushViewController(controller, animated: false)
    }
    
    @objc private func sendPurchaseOrderInfoBtnPressed(_ sender: UIButton) {
        var dict = [[String: Any]]()
        for item in purchaseProductList {
            let parameters: [String : Any] = [
                "productId" : item.productId,
                "firmId" : item.firmId,
                "purchaseQuantity" : item.purchaseAmount,
                "purchasePrice" : item.purchasePrice
            ]
            
            dict.append(parameters)
        }
        
        httpRequest.addNewPurchaseItemApi(dict) { result, error in
            print("sendPurchaseOrderInfoBtnPressed result: \(result)")
            
            // get responset 後的反應
            self.purchaseProductList = []
            
            self.commonFunc.refreshPurchaseProductList(self.purchaseProductList)
            self.finalPurchaseItemNoLab.text = "計算中"
            self.finalPurchasePriceLab.text = "計算中"
            
            self.mTV.reloadData()
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
