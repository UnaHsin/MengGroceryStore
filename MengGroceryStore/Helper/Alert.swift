//
//  Alert.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    ///使用單btn
    func showAlertWithAction(title: String? = nil, message: String, btnString: String, hander: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: btnString, style: .default, handler: hander)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    ///自定義btn文字
    func showAlertCustomizeBtnWithAction(okBtnTitle: String, noBtnTitle: String
        , title: String? = nil, message: String, hander: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okBtnTitle, style: .default, handler: hander)
        let cancel = UIAlertAction(title: noBtnTitle, style: .default)
        alert.addAction(cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
}
