//
//  SystemInfo.swift
//  ebank-kh3c
//
//  系統資訊
//
//  Created by fesc on 2017/11/15.
//  Copyright © 2017年 fesc. All rights reserved.
//

import UIKit

class SystemInfo {
    //Shared Instance
    static let si = SystemInfo()
    
    //iPhone or iPad...
    static let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    
    //original screen w and h (iphone 7)
    static let ORG_SCR_W: CGFloat = 375
    static let ORG_SCR_H: CGFloat = 667
    
    static var screenRect:CGRect?;
    static var screenWidth:CGFloat = 0;
    static var screenHeight:CGFloat = 0;
    static var screenScale:CGFloat = 1.0;
    static var statusBarHeight:CGFloat = 0;
    static var deviceScale:CGFloat = 1;
    //current image scale
    static var imageScale:CGFloat = 1.0;
    
    //device type
    //iPhone 系列
    //640x960 (320x480x2) for 4
    static let DEVICE_IPHONE4 = 0;
    
    //640x1136 (320x568x2) for 5, SE(1)
    static let DEVICE_IPHONE5 = 1;
    
    //750x1334 (375x667x2) for 6, 6S, 7, 8, SE(2)
    static let DEVICE_IPHONE6 = 2;
    
    //1080x1920 (414x736x3) for 6p, 7p, 8p
    static let DEVICE_IPHONE6_PLUS = 3;
    
    //1125x2436 (375x812x3) for x, xs, 11pro, 12mini,
    static let DEVICE_IPHONE_X = 4;
    
    //828x1792 (414x896x2) for xr, 11
    static let DEVICE_IPHONE_XR = 5;
    
    //1242x2688 (414x896x3) for XS-Max, 11pro-Max
    static let DEVICE_IPNONE_XRMAX = 6;
    
    //1170x2532 (390x844x3) for 12, 12pro
    static let DEVICE_IPHONE12 = 7;
    
    // (428x926x3) for 12pro-Max
    static let DEVICE_IPHONE12_PRO_MAX = 8
    
    //iPad 系列
    //768x1024  (768x1024x1)
    static let DEVICE_IPAD2 = 10;
    static let DEVICE_IPAD_MINI = 11;
    
    //1536x2048 (768x1024x2)
    static let DEVICE_IPAD_AIR = 12;
    //2048x2732
    static let DEVICE_IPAD_PRO_12_9 = 13;
    //1668x2224
    static let DEVICE_IPAD_PRO_10_5 = 14;
    //1536x2048
    static let DEVICE_IPAD_PRO_9_7 = 15;
    
    // get system misc info
    class func getSystemInfo() {
        
        //get screen size and scale
        screenRect = UIScreen.main.bounds
        screenWidth = screenRect!.width
        screenHeight = screenRect!.height
        
        //屏幕分辨率 1x, 2x, 3x
        screenScale = UIScreen.main.nativeScale
        
        let statusBarSize = UIApplication.shared.statusBarFrame
        
        statusBarHeight = Swift.min(statusBarSize.height, statusBarSize.width)
        
        //original width is 375, scale if width big than 375
        deviceScale = (screenWidth/ORG_SCR_W)
        
        //檢查目前裝置
        //iPhone 4s or below
        if (screenHeight==480) {
            imageScale = 0.72;
            
            //iPhone 5 image scale from 7
        } else if (screenHeight == 568) {
            imageScale = 0.85;
            
            //iPhone 6 image scale from 7
        } else if (screenHeight==667) {
            imageScale = 1;
        }
            //iPhone 6 plus image scale from 7
        else if (screenHeight==736) {
            imageScale = 1.1;
        }
            //iPhone X/Xs/11Pro image scale from 7
        else if (screenHeight==812) {
            imageScale = 1.2
            
        }
            //iPhone xr/11/xs-max/11pro-max
        else if (screenHeight==896) {
            imageScale = 1.3
            
            //iPhone 12pro-Max
        } else if (screenHeight == 926) {
            imageScale = 1.4
            
        }
            //iPad mini/iPad air/iPad pro
        else if (screenHeight==1024) {
            //iPad mini
            if (screenScale == 1) {
                imageScale = 0.8;
            }
                //iPad air
            else if (screenScale == 2) {
                imageScale = 1.6;
            }
                
            else if (screenScale == 3) {
                imageScale = 1.8
            }
            
            deviceScale = 2;
        }
        
        print("scrw:\(screenWidth)  scrh:\(screenHeight)  imageScale:\(imageScale)  statusHeight:\(statusBarHeight)  screenScale:\(screenScale)  deviceScale:\(deviceScale)");
        
        print("isIpadDevice: \(isIpadDevice())");
    }
    
    //是否 iPad
    class func isIpadDevice()->Bool {
        if (deviceIdiom == .pad) {
            return true;
        } else {
            return false;
        }
    }
    
    class func getScreenWidth()->CGFloat {
        return screenWidth
    }
    class func getScreenHeight()->CGFloat {
        return screenHeight
    }
    class func getScreenScale()->CGFloat {
        return screenScale
    }
    class func getStatusBarHeight() -> CGFloat {
        return statusBarHeight
    }
    class func getDeviceScale()->CGFloat {
        if screenScale > 2 {
            return deviceScale * 1.1
        }
        return deviceScale
    }
    class func getImageScale()->CGFloat {
        return imageScale
    }
    
    class func isTouchId(_ deviceModel: Model) -> Bool {
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone5S:
            return true
        case .iPhone6, .iPhone6Plus, .iPhone6S, .iPhone6SPlus:
            return true
        case .iPhone7, .iPhone7Plus:
            return true
        case .iPhoneSE, .iPhoneSE2:
            return true
        case .iPhone8, .iPhone8Plus:
            return true 
        default:
            return false
        }
    }
}


