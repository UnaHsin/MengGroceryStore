//
//  FirmInformationViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/15.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class FirmInformationViewController: UIViewController {

    private let vwScrollview = UIScrollView()
    private let mainView = UIView()
    private let firmNameText = UITextField()
    private let firmContactPersonText = UITextField()
    private let firmContactNumber = UITextField()
    private let firmVatNumberText = UITextField()
    
    private var keyboardHeightLayoutConstraint: Constraint?
    
    private let httpRequest = HttpRequest.share
    private let commonFunc = CommonFunc.share

    override func viewDidLoad() {
        super.viewDidLoad()

        // 頁面初始化
        viewInit()
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
    }

    //MARK: - @objc func
    @objc private func hideKeyboard() {
        firmNameText.resignFirstResponder()
        firmContactPersonText.resignFirstResponder()
        firmContactNumber.resignFirstResponder()
        firmVatNumberText.resignFirstResponder()
    }

}
