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
 * 3.庫存頁面
 * 4.銷售頁面
 * 5.廠商資訊頁
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
        gotoPurchaseBtn.addTarget(self, action: #selector(gotoRestockPageBtnPress(_:)), for: .touchUpInside)
        vwView.addSubview(gotoPurchaseBtn)
        gotoPurchaseBtn.snp.makeConstraints { make in
            make.top.equalTo(gotoProductListBtn.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalTo(vwView)
            make.width.equalTo(vwView).offset(-40 * deviceScale)
            //make.height.equalTo(btnH)
        }
        
        vwView.snp.makeConstraints { make in
            make.bottom.equalTo(gotoPurchaseBtn.snp.bottom).offset(20 * deviceScale)
        }
        
    }
    
    //MARK: - @objc func
    @objc private func gotoProductListBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProdustInfoListView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoPurchaseBtnPressed(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProdustInfoListView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
}

