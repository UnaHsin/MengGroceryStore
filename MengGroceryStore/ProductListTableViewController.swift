//
//  ProductListTableViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ProductListTableViewController: UITableViewController {
    
    let ref = Database.database().reference()
    let dbManager = ProductManager()
    //var productList = [Product]()
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
        
        navigationItem.title = "商品列表"

        viewInit()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        productList.removeAll()
        
        productList = dbManager.allProductInformation()
        print("productList: \(productList)")
        
        
    }
    
    func viewInit() {
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addProduct(_:)))
        navigationItem.rightBarButtonItem = add
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return productList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductListCell", for: indexPath) as! ProductListTableViewCell
        
        let product = productList[indexPath.row]
        cell.barCodeLab.text = product.barCode
        cell.productNameLab.text = product.productName

        return cell
    }
    
    @objc func addProduct(_ noti: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "RestockView")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let product = productList[indexPath.row]
        //print("點到：\(product.price)")
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailView") as! ProductDetailViewController
        //controller.product = product
        self.navigationController!.pushViewController(controller, animated: true)
        
    }
    
    func downloadFromFirebase() {
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
            self.tableView.reloadData()
        }
    }
}
