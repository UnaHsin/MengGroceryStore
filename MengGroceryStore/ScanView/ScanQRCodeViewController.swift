//
//  ScanQRCodeViewController.swift
//  MengGroceryStore
//
//  Created by Una Lee on 2019/9/25.
//  Copyright © 2019 Una Lee. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let width = SystemInfo.getScreenWidth()
    private let height = SystemInfo.getScreenHeight()
    private var line:UIImageView! = nil
    private let qrcodeWH:CGFloat = 300
    private let scanDescContent = "將條碼置於鏡頭範圍內以進行掃描"

    var viewNameStr = ""
    
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
        metadataOutput.rectOfInterest =  CGRect(x: 0.12, y: 0.12, width: qrcodeWH, height: qrcodeWH)
        
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
        
        switch viewNameStr {
        case ConfigSingleton.ADD_NEW_PRODUCT_INTO_VIEW_NAME:
            let controller = self.storyboard!.instantiateViewController(withIdentifier: ConfigSingleton.ADD_NEW_PRODUCT_INTO_VIEW_NAME) as! AddNewProductInfoViewController
            controller.barcodeNumber = value
            self.navigationController!.pushViewController(controller, animated: true)
            
        case ConfigSingleton.PURCHASE_PRODUCT_INFO_VIEW_NAME:
            let controller = self.storyboard!.instantiateViewController(withIdentifier: ConfigSingleton.PURCHASE_PRODUCT_INFO_VIEW_NAME) as! PurchaseProductInfoViewController
            controller.barcodeNumber = value
            self.navigationController!.pushViewController(controller, animated: true)
            
        case ConfigSingleton.INVENTORY_INFO_VIEW_NAME:
            let controller = self.storyboard!.instantiateViewController(withIdentifier: ConfigSingleton.INVENTORY_INFO_VIEW_NAME) as! InventoryInfoViewController
            controller.barcodeNumber = value
            self.navigationController!.pushViewController(controller, animated: true)
            
        default:
            break
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
        maskView.image = UIImage.maskImageWithMaskrect(maskRect: maskView.frame, clearRect: CGRect(x: (width-qrcodeWH)/2, y: (height-qrcodeWH)/2, width: qrcodeWH, height: qrcodeWH))
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
        line = UIImageView(frame: CGRect(x: (width-qrcodeWH)/2, y: height/2, width: qrcodeWH, height: 12))
        line.image = UIImage(named: "Icon_SaoLine")
        view.addSubview(line)
    }
    
    //MARK: - @objc func
    @objc func goBackHomePage(sender: UIBarButtonItem) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ViewController")
        navigationController!.pushViewController(controller!, animated: true)
    }
}
