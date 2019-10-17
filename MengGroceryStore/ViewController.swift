//
//  ViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/24.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

var productList = [ProductInformation]()

class ViewController: UIViewController {
    
    let dbManager = ProductManager()
    
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
        // Do any additional setup after loading the view.
        
        viewInit()
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
       productList = dbManager.allProductInformation()
        print("productList: \(productList)")
    }
    
    func downloadFromFirebaseDataBase() {
        let ref = Database.database().reference()
        ref.child("product").queryOrderedByKey().observe(.childAdded) { (snapshot) in
            
            if let productObject = snapshot.value as? [String: AnyObject] {
                print("productObject: \(productObject)")
                if let barCodeObject = productObject["barCode"] {
                    self.barCode = "\(barCodeObject)"
                }
                if let productNameObject = productObject["productName"] {
                    self.productName = "\(productNameObject)"
                }
                if let expireDateObject = productObject["expireDate"] {
                    self.expireDate = "\(expireDateObject)"
                }
                if let priceObject = productObject["price"] {
                    self.price = "\(priceObject)"
                }
                if let remainedQuantityObject = productObject["remainedQuantity"] {
                    self.remainedQuantity = "\(remainedQuantityObject)"
                }
                if let restockQuantityObject = productObject["restockQuantity"] {
                    self.restockQuantity = "\(restockQuantityObject)"
                }
                if let salesQuantityObject = productObject["salesQuantity"] {
                    self.salesQuantity = "\(salesQuantityObject)"
                }
                if let totalQuantityObject = productObject["totalQuantity"] {
                    self.totalQuantity = "\(totalQuantityObject)"
                }
                
                
                //productList.insert(Product(barCode: self.barCode, productName: self.productName, price: self.price, expireDate: self.expireDate, remainedQuantity: self.remainedQuantity, restockQuantity: self.restockQuantity, salesQuantity: self.salesQuantity, totalQuantity: self.totalQuantity), at: 0)
                
            }
            print("productList: \(productList)")
        }
    }
    
    
}

