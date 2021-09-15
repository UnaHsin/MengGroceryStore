//
//  AddNewProductViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/10/4.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class AddNewProductViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var barCodeNumberText: UITextField!
    @IBOutlet weak var productNameText: UITextField!
    @IBOutlet weak var productSalePriceText: UITextField!
    
//    //let dbManager = ProductManager()
//    var pageName = "AddNewProductView"
//    var keyboardHeight: CGFloat = 0
//    var barCodeNumber = ""
//    var productName = ""
//    var productSalePrice = 0
//    var isExist = false
//    
//    
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.title = "新增商品"
//        
//        //scrollView.keyboardDismissMode = .interactive
//        viewInit()
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        barCodeNumberText.text = barCodeNumber
//        
//        checkIsNewProduct(barCodeNumber)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        scrollView.endEditing(true)
//        //view.endEditing(true)
//    }
//    
//
//    @IBAction func scanBarCodeBtnPress(_ sender: Any) {
//        let controller = storyboard?.instantiateViewController(withIdentifier: "ScanQRCodeView") as! ScanQRCodeViewController
//        navigationController!.pushViewController(controller, animated: false)
//        
//    }
//    
//    @IBAction func addNewProductBtnPress(_ sender: Any) {
//        
//        productName = productNameText.text ?? ""
//        
//        if barCodeNumber == "" {
//            showAlert(message: "請輸入商品條碼")
//            return
//        }
//        
//        if productName == "" {
//            showAlert(message: "請輸入商品名稱")
//            return
//        }
//        
//        if productSalePriceText.text == "" {
//            showAlert(message: "請輸入商品售價")
//            return
//        } else {
//            productSalePrice = Int(productSalePriceText.text!)!
//        }
//
//        if isExist {
//            showAlert(message: "商品已存在\n請於進貨頁面查詢")
//            return
//        }
//        
//        if dbManager.insert(barCodeNumber, productName: productName, salePrice: Int64(productSalePrice)) {
//        productSalePriceText.text = ""
//        productNameText.text = ""
//        barCodeNumberText.text = ""
//            showToast(message: "商品新增成功")
//        }
//        
//    }
//    
//    func viewInit() {
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        
//        // prevents the scroll view from swallowing up the touch event of child buttons
//        tapGesture.cancelsTouchesInView = false
//        
//        scrollView.addGestureRecognizer(tapGesture)
//    }
//    
//    func checkIsNewProduct(_ barCode: String) {
//        isExist = dbManager.checkBarCodeIsExist(barCode)
//        if isExist {
//            showAlert(message: "商品資訊已存在")
//        }
//    }
//    
//    //func彈出鍵盤時提高畫面
//    @objc
//    func keyboardWillChangeFrame(_ notification:Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            self.scrollView.contentSize.height = self.scrollView.contentSize.height - self.keyboardHeight // scrollView contentSize 的高度容量扣掉鍵盤的高度
//            self.keyboardHeight = keyboardFrame.cgRectValue.height // keep 住鍵盤的高度
//        }
//    }
//    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            self.scrollView.contentSize.height = self.scrollView.contentSize.height + keyboardFrame.cgRectValue.height // scrollView contentSize 的容量加上鍵盤的高度
//        }
//    }
//    
//    @objc func keyboardHidden(_ notification:Notification) {
//        self.keyboardHeight = 0 // 鍵盤關掉，則要將 keep 住的高度歸 0。否則在下一起開啟鍵盤時，在 keyboardWillChangeFrame　扣掉上一次 keep 住的鍵盤高度
//    }
//    
//    @objc func dismissKeyBoard() {
//        self.view.endEditing(true)
//        self.scrollView.endEditing(true)
//    }
//    
//    @objc func hideKeyboard() {
//        barCodeNumberText.resignFirstResponder()
//        productNameText.resignFirstResponder()
//        productSalePriceText.resignFirstResponder()
//    }
}
