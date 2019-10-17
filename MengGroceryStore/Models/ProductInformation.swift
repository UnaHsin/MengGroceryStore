//
//  ProductInformation.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/10/4.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import SQLite

struct ProductInformation: Codable {
    var id: String?
    var barCode: String?        //商品id(barCode)
    var productName: String?    //商品名稱
    var salePrice: Int64?      //商品價錢
    var simpleSalesAmount: Int?   //購買數量
    
//    init() { }
//    init(_ barCode: String, _ productName: String, _ salePrice: Int)
}

class ProductManager {
    static let tableName = "productInformation"
    static let idKey = "id"
    static let barCodeKey = "barCode"
    static let productNameKey = "productName"
    static let salePriceKey = "salePrice"
    
    var db: Connection!
    var productInformationTable = Table(tableName)
    var idColumn = Expression<Int64>(idKey)
    var barCodeColumn = Expression<String>(barCodeKey)
    var productNameColumn = Expression<String>(productNameKey)
    var salePriceColumn = Expression<Int64>(salePriceKey)
    
    var productIDs = [Int64]()
    
    let vc = UIView.MHTool.getNowVc()
    
    init() {
        let filemanager = FileManager.default
        let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fullURLPath = documentsURL.appendingPathComponent("log.sqlite").path
        var isNewDB = false
        
        if !filemanager.fileExists(atPath: fullURLPath) {
            isNewDB = true
        }
        do {
            db = try Connection(fullURLPath)
        } catch {
            assertionFailure("Fail to create connection.")
        }
        
        if isNewDB {
            do {
                let command = productInformationTable.create { (builder) in
                    builder.column(idColumn, primaryKey: true)
                    builder.column(barCodeColumn, unique: true)
                    builder.column(productNameColumn)
                    builder.column(salePriceColumn)
                }
                try db.run(command)
                print("Product-Information table is created OK(新增資料庫Table).")
            } catch {
                assertionFailure("Fail to create table: \(error)")
            }
        } else {
            do {
               for product in try
                db.prepare(productInformationTable) {
                    productIDs.append(product[idColumn])
                }
            } catch {
                assertionFailure("Fail to create table: \(error)")
            }
            print("There are total \(productIDs.count) product information in DB.")
        }
    }
    
    var count: Int {
        return productIDs.count
    }
    
    func insert(_ barCode: String, productName: String, salePrice: Int64) {
        let command = productInformationTable.insert(barCodeColumn <- barCode,
                                                     productNameColumn <- productName,
                                                     salePriceColumn <- salePrice)
        do {
             let newProductId = try db.run(command)
            productIDs.append(newProductId)
            vc?.showAlert(message: "商品新增成功")
        } catch {
            assertionFailure("Fail to create table: \(error)")
        }
    }
    
    
    func allProductInformation() -> [ProductInformation] {
        var allProducts = [ProductInformation]()
        do {
            for productRow in try db.prepare(productInformationTable) {
                var product = ProductInformation(id: "\(productRow[idColumn])", barCode: "\(productRow[barCodeColumn])", productName: "\(productRow[productNameColumn])", salePrice: productRow[salePriceColumn], simpleSalesAmount: nil)
                allProducts.append(product)
            }
        } catch {
            assertionFailure("Fail to search all products from table: \(error)")
        }
        return allProducts
    }
    
    func checkBarCodeIsExist(_ barCode: String) -> Bool {
        var isExist = false
    
        do {
            for productRow in try db.prepare(productInformationTable.filter(barCodeColumn == barCode)) {
                var productBarCode = productRow[barCodeColumn]
                if productBarCode == barCode {
                    isExist = true
                }
            }
        } catch {
            assertionFailure("Fail to search product's barCode from table: \(error)")
        }
        return isExist
    }
    
    func searchBarCodeForSale(_ barCode: String) -> ProductInformation {
        var product = ProductInformation()
        do {
            for productRow in try db.prepare(productInformationTable.filter(barCodeColumn == barCode)) {
                product = ProductInformation(id: "\(productRow[idColumn])", barCode: "\(productRow[barCodeColumn])", productName: "\(productRow[productNameColumn])", salePrice: productRow[salePriceColumn], simpleSalesAmount: nil)
            }
        } catch {
            assertionFailure("Fail to searchBarCodeForSale from table: \(error)")
        }
        return product
    }
}
