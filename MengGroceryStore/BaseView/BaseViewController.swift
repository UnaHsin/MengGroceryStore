//
//  BaseViewController.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/3.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    let httpRequest = HttpRequest.share
    let commonFunc = CommonFunc.share

    override func viewDidLoad() {
        super.viewDidLoad()

        SystemInfo.getSystemInfo()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
