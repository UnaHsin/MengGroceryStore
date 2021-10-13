//
//  ScanSoppingCarView.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/13.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ScanSoppingCarViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let width = SystemInfo.getScreenWidth()
    private let height = SystemInfo.getScreenHeight()
    private var line:UIImageView! = nil
    private let qrcodeW:CGFloat = 300
    private let qrcodeH:CGFloat = 150
    private let scanDescContent = "將條碼置於鏡頭範圍內以進行掃描"
    
    private var dbProductList = [ProductInfoModel]()
    private var carProductList = [String]()
    private var finalCarProductList = [ShoppingCarInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "條碼掃描"
        
        viewInit()
        
        setCamera()
        
        creatBackGroundView()
        
        creatUI()
        
        
    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            captureSession.startRunning()
        }
        
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .notDetermined {
            checkCameraCanUse()
        }
    }
//
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //關閉監聽
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func viewInit() {
        
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "ic_6"), for: .normal)
        btn.addTarget(self, action: #selector(goBackHomePage(sender:)), for: .touchUpInside)
        btn.widthAnchor.constraint(equalToConstant: 32).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let rightBtn = UIBarButtonItem.init(customView: btn)
        navigationItem.rightBarButtonItem = rightBtn
        
        dbProductList = CommonFunc.share.getProductInfoList()
    }
    
    func checkCameraCanUse() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != AVAuthorizationStatus.authorized {
            showAlertCustomizeBtnWithAction(okBtnTitle: "設定", noBtnTitle: "確認", title: "「巷子內」想要取用您的相機", message: "請至設定開啟使用相機權限\n方能掃描條碼") { (action) in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
            }
        }
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
        
        //限制掃描區域
        //metadataOutput.rectOfInterest =  CGRect(x: 0.3, y: 0.3, width: qrcodeWH, height: qrcodeWH)
        metadataOutput.rectOfInterest =  CGRect(x: 0.12, y: 0.12, width: qrcodeW, height: qrcodeH)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //掃描框框
        previewLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        
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
        
        for item in dbProductList {
            // 存掃描後的商品內容
            if let nowBarcode = item.productBarcode {
                if value.elementsEqual(nowBarcode) {
                    print("\(item.productName)")
                    carProductList.append(nowBarcode)
//                    if let productId = item.productId, let productName = item.productName, let productPrice = item.productPrice {
//                        let carItem = ShoppingCarInfoModel(rcode: nil, rtMsg: nil, productId: productId, productBarcode: nowBarcode, productName: productName, productPrice: productPrice, saleAmount: nil, salePrice: nil)
//
//                        carProductList.append(carItem)
//                    }
                }
            } else {
                showToast(message: "條碼資料有誤")
            }
        }
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    /// 背景遮罩层
    func creatBackGroundView() {
        let maskView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        maskView.image = UIImage.maskImageWithMaskrect(maskRect: maskView.frame, clearRect: CGRect(x: (width-qrcodeW)/2, y: (height-qrcodeH)/2, width: qrcodeW, height: qrcodeH))
        self.view.addSubview(maskView)
    }
    
    /// 掃描說明內容
    func creatUI() {
        //提示信息
        let lblDesc = UILabel(frame: CGRect(x: 0, y: (height+400)/2, width: width, height: 50))
        lblDesc.text = scanDescContent
        lblDesc.textAlignment = .center
        lblDesc.textColor = UIColor.white
        lblDesc.font = UIFont.systemFont(ofSize: 17)
        view.addSubview(lblDesc)
        
        //掃描紅線
        line = UIImageView(frame: CGRect(x: (width-qrcodeW)/2, y: height/2, width: qrcodeW, height: 12))
        line.image = UIImage(named: "Icon_SaoLine")
        view.addSubview(line)
        
        let deviceScale = SystemInfo.getDeviceScale()
        let btnFont = UIFont.systemFont(ofSize: 15 * deviceScale)
        let continueBtn = UIButton(type: .custom)
        continueBtn.layer.cornerRadius = 7
        continueBtn.backgroundColor = .systemBlue
        continueBtn.setTitle("下一筆", for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.titleLabel?.font = btnFont
        continueBtn.titleLabel?.lineBreakMode = .byWordWrapping
        continueBtn.addTarget(self, action: #selector(continueBtnPressed(_:)), for: .touchUpInside)
        view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.top.equalTo(lblDesc.snp.bottom).offset(20 * deviceScale)
            make.centerX.equalToSuperview()
        }
        
        let scanDownBtn = UIButton(type: .custom)
        scanDownBtn.layer.cornerRadius = 7
        scanDownBtn.backgroundColor = .systemBlue
        scanDownBtn.setTitle("結束掃描", for: .normal)
        scanDownBtn.setTitleColor(.white, for: .normal)
        scanDownBtn.titleLabel?.font = btnFont
        scanDownBtn.titleLabel?.lineBreakMode = .byWordWrapping
        scanDownBtn.addTarget(self, action: #selector(scanDownBtnPressed(_:)), for: .touchUpInside)
        view.addSubview(scanDownBtn)
        scanDownBtn.snp.makeConstraints { make in
            make.centerY.equalTo(continueBtn)
            make.right.equalToSuperview().offset(-10 * deviceScale)
        }
    }
    
    //MARK: - @objc func
    @objc private func goBackHomePage(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        navigationController!.pushViewController(controller!, animated: true)
    }
    
    @objc private func continueBtnPressed(_ sender: UIButton) {
        captureSession.startRunning()
    }
    
    @objc private func scanDownBtnPressed(_ sender: UIButton) {
        print("到這: \(carProductList)")
        let countedSet = NSCountedSet(array: carProductList)
        
        // 算有幾筆重複的資訊
        for (key, value) in countedSet.dictionary {
            print("Element:", key, "count:", value)
            // 比對產品資料，並取得資訊
            for item in dbProductList {
                if item.productBarcode!.elementsEqual("\(key)") {
                    if let productId = item.productId, let productName = item.productName, let productPrice = item.productPrice {
                        
                        // 計算單筆項目總金額
                        let finalPrice = productPrice * value
                        
                        // 創建項目
                        let carItem = ShoppingCarInfoModel(rcode: nil, rtMsg: nil, productId: productId, productBarcode: item.productBarcode!, productName: productName, productPrice: productPrice, saleAmount: value, salePrice: finalPrice)
                        
                        // 存入購物車陣列中
                        finalCarProductList.append(carItem)
                    }
                }
            }
        }
        
        let controller = storyboard?.instantiateViewController(withIdentifier: ConfigSingleton.SHOPPING_CAR_INFO_VIEW_NAME) as! ShoppingCarViewController
        // 傳送資料
        controller.carProductList = finalCarProductList
        navigationController!.pushViewController(controller, animated: true)
    }
}
