//
//  SalesProductViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/26.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import AVFoundation

class SalesProductViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var salesTableView: UITableView!
    
    let dbManager = ProductManager()
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var salesList = [ProductInformation]()
    //var saleAmount = 0
    
    
    typealias DoneHandler = (_ result: Int) -> Void
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "銷售頁面"

        viewInit()
        setCamera()
        reloadSalesData()
    }
    
    @IBAction func keepScanBtnPress(_ sender: Any) {
        captureSession.startRunning()
    }
    
    func viewInit() {
        salesTableView.delegate = self
        salesTableView.dataSource = self
        
        let nextPage = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(gotoCheckOutPage(_:)))
        navigationItem.rightBarButtonItem = nextPage
    }
    
    func reloadSalesData() {
        
    }
    
    func setCamera() {
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //掃描框框
        previewLayer.frame = cameraView.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(value: stringValue)
            
        }
    }
    
    func found(value: String) {
        captureSession.stopRunning()
        print("bar code: \(value)")
        if !dbManager.checkBarCodeIsExist(value) {
            showAlertCustomizeBtnWithAction(okBtnTitle: "是", noBtnTitle: "否", title: "商品不存在", message: "是否新增商品？") { (action) in
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "AddNewProductView") as! AddNewProductViewController
                controller.barCodeNumber = value
                self.navigationController!.pushViewController(controller, animated: true)
            }
        }
        
        var product = dbManager.searchBarCodeForSale(value)
        
        let productId = product.id
        let productBarCode = product.barCode
        let productName = product.productName
        let productSalePrice = product.salePrice
        var saleAmount = 0
        
        if salesList.count > 0 {
            print("購物車有東西")
            for (index, one) in salesList.enumerated() {
                if one.barCode == value {
                    print("購物車有相同的商品，數量+1")
                    saleAmount = one.simpleSalesAmount!
                    saleAmount += 1
                    
                    salesList[index] = ProductInformation(id: productId, barCode: productBarCode, productName: productName, salePrice: productSalePrice, simpleSalesAmount: saleAmount)
                    salesTableView.reloadData()
                    return
                }
            }
            print("購物車有東西，但沒有同樣商品")
            saleAmount += 1
            salesList.insert(ProductInformation(id: productId, barCode: productBarCode, productName: productName, salePrice: productSalePrice, simpleSalesAmount: saleAmount), at: 0)
            salesTableView.reloadData()
            return
        } else {
            print("進入空的購物車")
            saleAmount += 1
            salesList.insert(ProductInformation(id: productId, barCode: productBarCode, productName: productName, salePrice: productSalePrice, simpleSalesAmount: saleAmount), at: 0)
            salesTableView.reloadData()
        }
        
        
    }
    
    /// 掃描說明內容
    func creatUI() {
        
//        //掃描紅線
//        line = UIImageView(frame: CGRect(x: (width-qrcodeWH)/2, y: height/2, width: qrcodeWH, height: 12))
//        line.image = UIImage(named: "Icon_SaoLine")
//        view.addSubview(line)
    }
    
    //MARK: - Table View
     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return salesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SalesProductCell", for: indexPath) as! SalesProductTableViewCell
        
        let salesProduct = salesList[indexPath.row]
        cell.barCodeLab.text = salesProduct.barCode
        cell.productNameLab.text = salesProduct.productName
        cell.simpleSalesQuantityLab.text = "\(salesProduct.simpleSalesAmount!)"
        
        return cell
    }
    
    @objc func gotoCheckOutPage(_ barItem: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "CheckOutView") as! CheckOutViewController
        controller.salesList = salesList
        navigationController!.pushViewController(controller, animated: true)
    }
    
    

}
