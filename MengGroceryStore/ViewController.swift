//
//  ViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/24.
//  Copyright © 2019 Una Lee. All rights reserved.
//
/**
 * 首頁
 * 可前往：
 * 1.商品資訊頁
 * 2.進貨頁面
 * 3.新增進貨頁面
 * 4.廠商資訊頁
 * 5.庫存頁面
 * 6.銷售頁面
 *
 */

import UIKit

class ViewController: BaseViewController {
    
    private let vwScrollview = UIScrollView()
    private let vwView = UIView()
    
    //let dbProductManager = ProductManager()
    //let dbSaleOrderManager = SaleListManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewInit()
        
        navigationController?.navigationBar.barTintColor = Colors.mainColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }

    @IBAction func gotoInsertProductPageBtnPress(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddNewProductView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @IBAction func gotoRestockPageBtnPress(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProductListTable")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    
    @IBAction func gotoSalesProductPageBtnPress(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "SalesProductView") 
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    func viewInit() {
    
        //navigationController?.tab = Colors.mainColor
        
        // 取得螢幕資訊
        var deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
        vwScrollview.backgroundColor = .white
        view.addSubview(vwScrollview)
        vwScrollview.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        vwView.backgroundColor = .white
        vwScrollview.addSubview(vwView)
        vwView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(vwScrollview)
        }
        
        let btnFont = UIFont.systemFont(ofSize: 30 * deviceScale)
        //let btnH = 40 * deviceScale
        
        let gotoProductListBtn = UIButton(type: .custom)
        //gotoProductListBtn.layer.cornerRadius = 7
        gotoProductListBtn.setTitle("商品資訊", for: .normal)
        gotoProductListBtn.setTitleColor(Colors.lightGreenColor, for: .normal)
        gotoProductListBtn.titleLabel?.font = btnFont
        gotoProductListBtn.addTarget(self, action: #selector(gotoProductListBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoProductListBtn)
        gotoProductListBtn.snp.makeConstraints { make in
            make.top.equalTo(vwView.snp.top).offset(50 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        let gotoPurchaseBtn = UIButton(type: .custom)
        gotoPurchaseBtn.setTitle("進貨頁面", for: .normal)
        gotoPurchaseBtn.setTitleColor(.blue, for: .normal)
        gotoPurchaseBtn.titleLabel?.font = btnFont
        gotoPurchaseBtn.addTarget(self, action: #selector(gotoPurchaseBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoPurchaseBtn)
        gotoPurchaseBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoProductListBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        let gotoNewPurchaseInfoBtn = UIButton(type: .custom)
        gotoNewPurchaseInfoBtn.setTitle("新增進貨", for: .normal)
        gotoNewPurchaseInfoBtn.setTitleColor(.red, for: .normal)
        gotoNewPurchaseInfoBtn.titleLabel?.font = btnFont
        gotoNewPurchaseInfoBtn.addTarget(self, action: #selector(gotoNewPurchaseInfoBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoNewPurchaseInfoBtn)
        gotoNewPurchaseInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoPurchaseBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        let gotoFirmInfoBtn = UIButton(type: .custom)
        gotoFirmInfoBtn.setTitle("廠商資訊", for: .normal)
        gotoFirmInfoBtn.setTitleColor(Colors.yellowColor, for: .normal)
        gotoFirmInfoBtn.titleLabel?.font = btnFont
        gotoFirmInfoBtn.addTarget(self, action: #selector(gotoFirmInfoBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoFirmInfoBtn)
        gotoFirmInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoNewPurchaseInfoBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        let gotoInventoryInfoBtn = UIButton(type: .custom)
        gotoInventoryInfoBtn.setTitle("庫存資訊", for: .normal)
        gotoInventoryInfoBtn.setTitleColor(.black, for: .normal)
        gotoInventoryInfoBtn.titleLabel?.font = btnFont
        gotoInventoryInfoBtn.addTarget(self, action: #selector(gotoInventoryInfoBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoInventoryInfoBtn)
        gotoInventoryInfoBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoFirmInfoBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        let gotoShoppingCarBtn = UIButton(type: .custom)
        gotoShoppingCarBtn.setTitle("購物車", for: .normal)
        gotoShoppingCarBtn.setTitleColor(.black, for: .normal)
        gotoShoppingCarBtn.titleLabel?.font = btnFont
        gotoShoppingCarBtn.addTarget(self, action: #selector(gotoShoppingCarBtnPressed(_:)), for: .touchUpInside)
        vwView.addSubview(gotoShoppingCarBtn)
        gotoShoppingCarBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoInventoryInfoBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        vwView.snp.makeConstraints { make in
            make.bottom.equalTo(gotoShoppingCarBtn.snp.bottom).offset(20 * deviceScale)
        }
        
    }
    
    //MARK: - @objc func
    @objc private func gotoProductListBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.PRODUCT_INFO_LIST_VIEW_NAME)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoPurchaseBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.PURCASH_HISTORY_LIST_VIEW_NAME)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoNewPurchaseInfoBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.PURCHASE_INFO_LIST_VIEW_NAME)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoFirmInfoBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "FirmInfoListView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoInventoryInfoBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "InventoryInfoView")
        navigationController!.pushViewController(controller!, animated: true)
        
    }
    
    @objc private func gotoShoppingCarBtnPressed(_ sender: UIButton) {
        
        //let controller = storyboard?.instantiateViewController(withIdentifier: "ScanSoppingCarView")
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.SHOPPING_CAR_INFO_VIEW_NAME)
        navigationController!.pushViewController(controller!, animated: true)
        
    }
}

