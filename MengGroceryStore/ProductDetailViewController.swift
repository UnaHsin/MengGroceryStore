//
//  ProductDetailViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productNameLab: UILabel!
    @IBOutlet weak var barCodeText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var remainedQuantityText: UITextField!
    @IBOutlet weak var salesQuantityText: UITextField!
    @IBOutlet weak var restockQuantityText: UITextField!
    @IBOutlet weak var totalQuantityText: UITextField!
    @IBOutlet weak var expireDateText: UITextField!
    @IBOutlet weak var updateProductDetailBtn: UIButton!
    
    let ref = Database.database().reference()
    var keyboardHeight: CGFloat = 0
    var product = Product()
    var barCode = ""
    var productName = ""
    var price = ""
    var expireDate = ""
    var remainedQuantity = ""
    var restockQuantity = ""
    var salesQuantity = ""
    var totalQuantity = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "商品資訊"
        // Do any additional setup after loading the view.
        viewInit()
        setTextContent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func updateProductDetailBtnPress(_ sender: Any) {
        print("\(priceText.text!)")
        barCode = barCodeText.text ?? ""
        productName = productNameLab.text ?? ""
        
        if priceText.text == "" {
            showAlert(message: "請輸入販售價錢")
        }
        
        price = priceText.text!
        expireDate = expireDateText.text ?? ""
        remainedQuantity = remainedQuantityText.text ?? "0"
        restockQuantity = restockQuantityText.text ?? "0"
        salesQuantity = salesQuantityText.text ?? "0"
        totalQuantity = totalQuantityText.text ?? "0"
        
        showAlertCustomizeBtnWithAction(okBtnTitle: "確定", noBtnTitle: "取消", message: "確定修改商品資訊？") { (action) in
            
            self.ref.child("product").child("\(self.barCode)").updateChildValues(["barCode": self.barCode, "expireDate": self.expireDate, "price": self.price, "productName": self.productName, "remainedQuantity": self.remainedQuantity, "restockQuantity": self.restockQuantity, "salesQuantity": self.salesQuantity, "totalQuantity": self.totalQuantity])
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductListTable")
            self.navigationController!.pushViewController(controller!, animated: true)
        }
    }
    
    @IBAction func deleteBtnPress(_ sender: Any) {
        barCode = barCodeText.text!
        productName = product.productName ?? ""
        
        showAlertCustomizeBtnWithAction(okBtnTitle: "確定", noBtnTitle: "取消", message: "將刪除\(productName)的商品資訊\n請確認是否刪除") { (action) in
            self.ref.child("product").child("\(self.barCode)").removeValue()
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductListTable")
            self.navigationController!.pushViewController(controller!, animated: true)
            
        }
        
    }
    
    func viewInit() {
        let edit = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGoodsInformation(_:)))
        navigationItem.rightBarButtonItem = edit
        
        barCodeText.isEnabled = false
        priceText.isEnabled = false
        priceText.isEnabled = false
        remainedQuantityText.isEnabled = false
        salesQuantityText.isEnabled = false
        restockQuantityText.isEnabled = false
        totalQuantityText.isEnabled = false
        expireDateText.isEnabled = false
        
        updateProductDetailBtn.isHidden = true
    }

    func setTextContent() {
        productNameLab.text = product.productName
        barCodeText.text = product.barCode
        priceText.text = product.price
        remainedQuantityText.text = product.remainedQuantity
        salesQuantityText.text = product.salesQuantity
        restockQuantityText.text = product.restockQuantity
        totalQuantityText.text = product.totalQuantity
        expireDateText.text = product.expireDate
    }
    
    @objc func editGoodsInformation(_ sender: UIBarButtonItem) {
        priceText.isEnabled = true
        priceText.isEnabled = true
        remainedQuantityText.isEnabled = true
        salesQuantityText.isEnabled = true
        restockQuantityText.isEnabled = true
        totalQuantityText.isEnabled = true
        expireDateText.isEnabled = true
        
        updateProductDetailBtn.isHidden = false
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
