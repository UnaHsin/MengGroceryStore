//
//  ProdustInfoListViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ProdustInfoListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    //view
    private var mTV: UITableView!
    private var mSC: UISearchController!
    private let mView = UIView()
    private let tvCellName = "ProductInfoTableCell"
    private let barcodeItemLab = UILabel()
    private let nameItemLab = UILabel()

    private let httpRequest = HttpRequest.share
    private let commonFunc = CommonFunc.share
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    // data
    private var productInfoList = [ProductInfoModel]()
    //搜尋結果集合
    var filterDataList = [ProductInfoModel]()
    //是否顯示搜尋的結果
    var isShowSearchResult = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "商品列表"

        //畫面初始化
        viewInit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表單ui初始化
        tableViewInit()
        
        // 取得商品資訊
        getAllProductInfoList()
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
                                         action: #selector(goBack(sender:)))
        navigationItem.leftBarButtonItem = backButton
        
        searchControllerInit()
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewProductInfo(_:)))
        
        view.addSubview(mView)
        mView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        barcodeItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        barcodeItemLab.text = "商品條碼"
        mView.addSubview(barcodeItemLab)
        barcodeItemLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }

        nameItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        nameItemLab.text = "商品名稱"
        mView.addSubview(nameItemLab)
        nameItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(barcodeItemLab)
            make.left.equalTo(barcodeItemLab.snp.right).offset(15 * deviceScale)
        }

        //分隔線設定
        let line = UIView()
        line.backgroundColor = .lightGray
        mView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.equalTo(nameItemLab.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(1.5)
            make.width.equalToSuperview().offset(-20)
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
        mTV.register(ProductInfoTableViewCell.self, forCellReuseIdentifier: tvCellName)
        view.addSubview(mTV)
        mTV.snp.makeConstraints { (make) in
            make.top.equalTo(nameItemLab.snp.bottom).offset(5 * deviceScale)
            make.bottom.left.right.equalToSuperview()
        }
    }
    
    private func searchControllerInit() {
        mSC = UISearchController(searchResultsController: nil)
        
        //searchBar點選時，不上跳
        mSC.hidesNavigationBarDuringPresentation = false
        mSC.searchBar.placeholder = "搜尋"
        mSC.searchBar.sizeToFit()
        mSC.searchResultsUpdater = self
        mSC.searchBar.delegate = self
        //預設為 true, 若是沒改為false, 則在搜尋時整個TableView的背景色會變成灰底的
        mSC.dimsBackgroundDuringPresentation = false
        mSC.searchBar.backgroundColor = .white
        mSC.searchBar.isTranslucent = true
        navigationItem.searchController = mSC
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowSearchResult {
            //若是有查詢結果則顯示查詢結果集合裡的資料
            return filterDataList.count
        } else {
            return productInfoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTV.dequeueReusableCell(withIdentifier: tvCellName) as! ProductInfoTableViewCell
        
        if isShowSearchResult {
            // 搜尋陣列中 資料
            let item = filterDataList[indexPath.row]
            cell.getInformation(item.productBarcode!, item.productName)
        } else {
            let item = productInfoList[indexPath.row]
            cell.getInformation(item.productBarcode!, item.productName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell 的選取狀態
        mTV.deselectRow(at: indexPath, animated: true)
        //關閉螢幕小鍵盤
        mSC.searchBar.resignFirstResponder()
        
        var productItem = ProductInfoModel()
        if isShowSearchResult {
            productItem = filterDataList[indexPath.row]
        } else {
            productItem = productInfoList[indexPath.row]
        }
        
        //轉跳
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "ProductInformationView") as! ProductInformationViewController
        controller.productItem = productItem
        self.navigationController!.pushViewController(controller, animated: false)
        
    }

    //MARK: - UISearchBar Delegate
    // 當在searchBar上開始輸入文字時
    // 當「準備要在searchBar輸入文字時」、「輸入文字時」、「取消時」三個事件都會觸發該delegate
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
        if mSC.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
            
            isShowSearchResult = false
            //畫面重 load
            mTV.reloadData()
            
            return
        }
        
        filterDataSource()
    }
    
    //點擊searchBar的搜尋按鈕時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //關閉螢幕小鍵盤
        print("關閉搜尋螢幕小鍵盤")
        mSC.searchBar.resignFirstResponder()
    }
    
    // 過濾被搜陣列裡的資料
    private func filterDataSource() {
        // 使用高階函數來過濾掉陣列裡的資料
        filterDataList = productInfoList.filter({ fruit in
            if fruit.productName?.range(of: mSC.searchBar.text!) != nil {
                return fruit.productName?.range(of: mSC.searchBar.text!) != nil
            } else {
                return fruit.productBarcode?.range(of: mSC.searchBar.text!) != nil
            }
        })
        
        if self.filterDataList.count > 0 {
            isShowSearchResult = true
            mTV.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
        } else {
            mTV.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
            // 可加入一個查找不到的資料的label來告知使用者查不到資料...
            isShowSearchResult = true
            filterDataList = []
        }
        
        mTV.reloadData()
    }
    
    //MARK: - @objc func
    @objc private func addNewProductInfo(_ sender: UIBarButtonItem) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddNewProductInfoView") 
        navigationController!.pushViewController(controller, animated: false)
    }
    
    @objc func goBack(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    //MARK: - Api func
    private func getAllProductInfoList() {
        commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getAllProductInfoApi { result, error in
            let funcName = "getAllProductInfo"
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
            print("getAllProductInfoList result: \(result)")
            
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
            self.productInfoList = resultObject
            self.mTV.reloadData()
        }
    }

}
