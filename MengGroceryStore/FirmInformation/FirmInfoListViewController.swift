//
//  FirmInfoListViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/15.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class FirmInfoListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating {
    
    //view
    private var mTV: UITableView!
    private var mSC: UISearchController!
    private let mView = UIView()
    private let tvCellName = "FirmInfoTableCell"
    private let varItemLab = UILabel()
    private let nameItemLab = UILabel()

    
    // data
    private var firmInfoList = [FirmInfoModel]()
    //搜尋結果集合
    var filterDataList = [FirmInfoModel]()
    //是否顯示搜尋的結果
    var isShowSearchResult = false
    
    //get system device information
    private var deviceScale: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "廠商列表"

        // 頁面初始化
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 表單ui初始化
        tableViewInit()
        
        // 取得商品資訊
        getAllFirmInfoList()
    }
    

    //MARK: - view init
    private func viewInit() {
        // 取得螢幕資訊
        deviceScale = SystemInfo.getDeviceScale()
        if deviceScale < 1 {
            deviceScale = 1
        }
        
        // 搜尋欄位初始化
        searchControllerInit()
        
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewFirmInfo(_:)))
        
        view.addSubview(mView)
        mView.snp.makeConstraints { make in
            make.top.equalTo(view.safeArea.top)
            make.bottom.left.right.equalToSuperview()
        }
        
        varItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        varItemLab.text = "統一編號"
        mView.addSubview(varItemLab)
        varItemLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        nameItemLab.labInit(textColor: .systemBlue, textPlace: .left, font: aFont)
        nameItemLab.text = "廠商名稱"
        mView.addSubview(nameItemLab)
        nameItemLab.snp.makeConstraints { make in
            make.centerY.equalTo(varItemLab)
            make.left.equalTo(varItemLab.snp.right).offset(15 * deviceScale)
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
        mTV.register(FirmInfoTableViewCell.self, forCellReuseIdentifier: tvCellName)
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
            return firmInfoList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mTV.dequeueReusableCell(withIdentifier: tvCellName) as! FirmInfoTableViewCell
        
        if isShowSearchResult {
            // 搜尋陣列中 資料
            let item = filterDataList[indexPath.row]
            cell.getInformation(item.firmVatNumber!, item.firmName)
        } else {
            let item = firmInfoList[indexPath.row]
            cell.getInformation(item.firmVatNumber!, item.firmName)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell 的選取狀態
        mTV.deselectRow(at: indexPath, animated: true)
        //關閉螢幕小鍵盤
        mSC.searchBar.resignFirstResponder()
        
        var firmItem = FirmInfoModel()
        if isShowSearchResult {
            firmItem = filterDataList[indexPath.row]
        } else {
            firmItem = firmInfoList[indexPath.row]
        }
        
        //轉跳
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "FirmInformationView") as! FirmInformationViewController
        //controller.productItem = firmItem
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
        //print("searchText: \(mSC.searchBar.text!)")
        
        // 使用高階函數來過濾掉陣列裡的資料
        filterDataList = firmInfoList.filter({ fruit in
            if fruit.firmVatNumber?.range(of: mSC.searchBar.text!) != nil {
                
                return fruit.firmVatNumber?.range(of: mSC.searchBar.text!) != nil
            } else {
                return fruit.firmName?.range(of: mSC.searchBar.text!) != nil
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
    
    //MARK: - func
    private func getAllFirmInfoList() {
        //commonFunc.showLoading(showMsg: "Loading...")
        httpRequest.getAllFirmInfoApi { result, error in
            let funcName = "getAllFirmInfoList"
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
            print("getAllFirmInfoList result: \(result)")
            
            guard let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                print("Fail to generate \(funcName) jsonData.")
                return
            }
            let decoder = JSONDecoder()
            guard let resultObject = try? decoder.decode([FirmInfoModel].self, from: jsonData) else {
                print("\(funcName) Fail to decoder jsonData")
                return
            }
            
            // TODO null
            self.firmInfoList = resultObject
            self.mTV.reloadData()
        }
    }
    
    //MARK: - @objc func
    @objc private func addNewFirmInfo(_ sender: UIBarButtonItem) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "AddNewFirmInfoView")
        navigationController!.pushViewController(controller, animated: false)
        
    }
}
