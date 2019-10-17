//
//  RestockViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RestockViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barCodeText: UITextField!
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var restockQuantityText: UITextField!
    @IBOutlet weak var productExpireDateText: UITextField!
    
    let ref = Database.database().reference()
    var keyboardHeight: CGFloat = 0
    var barCodeNumber = ""
    var expireDate = ""
    var productName = ""
    var restockQuantity = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "新增商品"
       
        viewInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        barCodeText.text = barCodeNumber
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func gotoQRcodePageBtnPress(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeView")
        navigationController!.pushViewController(controller!, animated: false)
    }
    
    
    @IBAction func sendRestockGoodsInformationBtnPress(_ sender: Any) {
        expireDate = productExpireDateText.text!
        productName = productNameText.text!
        restockQuantity = Int(restockQuantityText.text!)!
        ref.child("product").child(barCodeNumber).setValue(["barCode":barCodeNumber,
                                "expireDate": expireDate, "productName": productName, "restockQuantity": restockQuantity,
                                "totalQuantity": restockQuantity,
                                "salesQuantity": 0,
                                "remaineQuantity": restockQuantity])
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        navigationController!.pushViewController(controller!, animated: false)
    }
    
    func viewInit() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        self.view.addGestureRecognizer(tap) // to Replace "TouchesBegan"
    }
    
    //func彈出鍵盤時提高畫面
    @objc
    func keyboardWillChangeFrame(_ notification:Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.scrollView.contentSize.height = self.scrollView.contentSize.height - self.keyboardHeight // scrollView contentSize 的高度容量扣掉鍵盤的高度
            self.keyboardHeight = keyboardFrame.cgRectValue.height // keep 住鍵盤的高度
        }
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            self.scrollView.contentSize.height = self.scrollView.contentSize.height + keyboardFrame.cgRectValue.height // scrollView contentSize 的容量加上鍵盤的高度
        }
    }

    @objc func keyboardHidden(_ notification:Notification) {
        self.keyboardHeight = 0 // 鍵盤關掉，則要將 keep 住的高度歸 0。否則在下一起開啟鍵盤時，在 keyboardWillChangeFrame　扣掉上一次 keep 住的鍵盤高度
    }
    
    @objc func dismissKeyBoard() {
        self.view.endEditing(true)
    }
    
}
