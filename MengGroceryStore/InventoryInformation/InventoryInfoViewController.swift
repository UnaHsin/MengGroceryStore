//
//  InventoryInfoViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/10.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class InventoryInfoViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    //view
    private var mainTV: UITableView!
    private let mainView = UIView()
    private let searchView = UIView()
    private let searchText = UITextField()
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    private let tvCellName = "InventoryInfoTableViewCell"
    
    private var inventoryInfoList = [InventoryInfoModel]()
    
    var barcodeNumber = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // 畫面初始化
        viewInit()
        
        // 表單ui初始化
        tableViewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 取得庫存資料
        getInventoryInfoList()
        
        if barcodeNumber.count > 1 {
            searchText.text = barcodeNumber
        }
        
        
    }
    
    //MARK: - view init
    private func viewInit() {
        mainView.backgroundColor = .white
        view.addSubview(mainView)
        
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
        
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        searchView.backgroundColor = .yellow
        mainView.addSubview(searchView)
        searchView.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.top)
            make.width.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.07)
        }
        
        let textFont = UIFont.systemFont(ofSize: 20 * deviceScale)
        searchText.borderStyle = .roundedRect
        searchText.returnKeyType = .done
        searchText.font = textFont
        searchView.addSubview(searchText)
        searchText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }
        
        let scanIconStack = UIStackView()
        scanIconStack.spacing = 5
        scanIconStack.distribution = .fillProportionally
        scanIconStack.axis = .horizontal
        searchView.addSubview(scanIconStack)
        scanIconStack.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.top.equalTo(searchView.snp.top).offset(5)
            make.bottom.equalTo(searchView.snp.bottom).offset(-5)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        
        
        let scanImg = UIImage(named: "scan")
        let scanBtn = UIButton(type: .custom)
        scanBtn.setImage(scanImg, for: .normal)
        scanBtn.contentMode = .scaleAspectFit
        scanBtn.contentHorizontalAlignment = .fill
        scanBtn.contentVerticalAlignment = .fill
        scanBtn.addTarget(self, action: #selector(gotoScanView(_:)), for: .touchUpInside)
        scanIconStack.addArrangedSubview(scanBtn)
//        searchView.addSubview(scanBtn)
//        scanBtn.snp.makeConstraints { make in
//            make.right.equalToSuperview().offset(-15)
//            make.top.equalTo(searchView.snp.top).offset(5)
//            make.bottom.equalTo(searchView.snp.bottom).offset(-5)
//            make.width.equalTo(scanBtn.snp.height)
//        }
        
        let searchImg = UIImage(named: "search")
        let searchBtn = UIButton(type: .custom)
        searchBtn.setImage(searchImg, for: .normal)
        searchBtn.contentMode = .scaleAspectFit
        searchBtn.contentHorizontalAlignment = .fill
        searchBtn.contentVerticalAlignment = .fill
        searchBtn.addTarget(self, action: #selector(searchBtnPressed(_:)), for: .touchUpInside)
        scanIconStack.addArrangedSubview(searchBtn)
//        searchView.addSubview(searchBtn)
//        searchBtn.snp.makeConstraints { make in
//            make.centerY.equalTo(scanBtn)
//            make.right.equalTo(scanBtn.snp.left).offset(-10)
//            make.width.equalTo(scanBtn.snp.width).multipliedBy(0.7)
//            make.height.equalTo(searchBtn.snp.width)
//        }
        
        searchText.snp.makeConstraints { make in
            make.right.equalTo(scanIconStack.snp.left).offset(-5)
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
        mainTV.register(InventoryInfoTableViewCell.self, forCellReuseIdentifier: tvCellName)
        mainView.addSubview(mainTV)
        mainTV.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return inventoryInfoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tvCellName) as! InventoryInfoTableViewCell
        
        let item = inventoryInfoList[indexPath.row]
        cell.productItemNoStr = commonFunc.getItemNo(indexPath.row)
        cell.productBarcodeStr = item.productBarcode
        cell.productNameStr = item.productName
        //cell.productInventoryAmounStr = "9999"
        if let inventoryAmount = item.inventoryAmount {
            cell.productInventoryAmounStr = "\(inventoryAmount)"
        }
        
    
        
        return cell
    }
    
    //MARK: - func
    private func getInventoryInfoList() {
        commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getInventoryInfoListApi { result, error in
            let funcName = "getInventoryInfoListApi"
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
            print("getInventoryInfoList result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([InventoryInfoModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.inventoryInfoList = resultObject
            self.mainTV.reloadData()
        }
    }
    
    //MARK: - @objc func
    @objc private func goBack(_ sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.HOME_VIEW_NAEM)
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func gotoScanView(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.SCAN_QR_CODE_VIEW_NAME) as! ScanQRCodeViewController
        controller.viewNameStr = ConfigSingleton.INVENTORY_INFO_VIEW_NAME
        navigationController!.pushViewController(controller, animated: true)
    }
    
    @objc private func searchBtnPressed(_ sender: UIButton) {
        
    }
}
