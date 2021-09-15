//
//  CommonFunc.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/3.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import SVProgressHUD

class CommonFunc {
    
    static let share = CommonFunc()
    
    
    func showLoading(showMsg: String) {
        SVProgressHUD.show(withStatus: showMsg)
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    func closeLoading() {
        SVProgressHUD.dismiss()
    }
}

//MARK: - extension UILable
extension UILabel {
    func labInit(textColor: UIColor, textPlace: NSTextAlignment, font: UIFont) {
        self.textColor = textColor
        self.textAlignment = textPlace
        self.lineBreakMode = .byWordWrapping
        self.numberOfLines = 0
        self.font = font
    }
}

