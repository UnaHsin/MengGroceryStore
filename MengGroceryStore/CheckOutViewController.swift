//
//  CheckOutViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/27.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit

class CheckOutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var finalAmountLab: UILabel!
    @IBOutlet weak var payAmountField: UITextField!
    @IBOutlet weak var makeChangeAmountLab: UILabel!
    
//    typealias DoneHandler = (_ result: Int) -> Void
    var salesList = [ProductInfoModel]()
//    let dbManager = ProductManager()
//    let saleManager = SaleListManager()
//    var finalAmount = 0
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        print("CheckOutView salesList: \(salesList)")
//
//        viewInit()
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
//    
//    func viewInit() {
//        checkFinalAmount { (finalAmount) in
//            self.finalAmount = finalAmount
//            self.finalAmountLab.text = "\(finalAmount)"
//        }
//    }
//    
//    
//    @IBAction func checkPayment(_ sender: Any) {
//        let paymentAmount = Int(payAmountField.text ?? "0")
//        let changeDollars = paymentAmount! - finalAmount
//        if changeDollars < 0 {
//            showAlert(message: "賠錢生意")
//            return
//        }
//        makeChangeAmountLab.text = "\(changeDollars)"
//        
//        let saleOrderDate = getOrderDate()
//        let salerOrderNumber = getOrderNumber(nowDate: saleOrderDate)
//        print("saleOrderDate: \(saleOrderDate), salerOrderNumber: \(salerOrderNumber)")
//        //saleManager.insert(<#T##saleOrderNumber: String##String#>, saleOrderDate, Int64(finalAmount))
//    }
//    
    //MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return salesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutCell", for: indexPath) as! CheckOutTableViewCell
        
//        let salesProduct = salesList[indexPath.row]
//        cell.productNameLab.text = salesProduct.productName
//        cell.simpleSalesQuantityLab.text = "\(salesProduct.simpleSalesAmount ?? 0)"
        
        return cell
    }
//
//    
//    func checkFinalAmount(totalAmount: @escaping DoneHandler) {
//        var productInfo: ProductInformationSQL
//        var finalAmount = 0
//        
//        for product in salesList {
//            if let productBarCode = product.barCode {
//                productInfo = dbManager.searchBarCodeForSale(productBarCode)
//                let productPrice = NSNumber(value: productInfo.salePrice ?? 0).intValue
//                let salesAmount = product.simpleSalesAmount
//                let finalSimpleProductPrice = productPrice * salesAmount!
//                
//                finalAmount += finalSimpleProductPrice
//            }
//            
//        }
//        print("total amount: \(finalAmount)")
//        totalAmount(finalAmount)
//    }
//   
//    func getOrderDate() -> String {
//        let date = Date()
//        let dateFormat = DateFormatter()
//        dateFormat.dateFormat = "yyyy/MM/dd HH:mm:ss"
//        let dateStr = dateFormat.string(from: date)
//        
//        return dateStr
//    }
//    
//    func getOrderNumber(nowDate: String) -> String {
//        let orderNumber1 = nowDate.replacingOccurrences(of: "/", with: "")
//        let orderNumber2 = orderNumber1.replacingOccurrences(of: ":", with: "")
//        let orderNumber3 = orderNumber2.replacingOccurrences(of: " ", with: "")
//        
//        return orderNumber3
//    }

}
