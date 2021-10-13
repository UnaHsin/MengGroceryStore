//
//  ProductInfoCollectionViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/22.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ProductInfoCollectionViewCell: UICollectionViewCell {
    let deviceScale = SystemInfo.getDeviceScale()
    
    let firmTitleLab = UILabel()
    var titleStr: String? {
        didSet {
            firmTitleLab.text = titleStr
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化
    func setupCell() {
        contentView.layer.borderWidth = 2
        contentView.layer.cornerRadius = 8
        contentView.layer.borderColor = UIColor.systemBlue.cgColor
        
        let labSpace = 5 * deviceScale
        let nFont:UIFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        firmTitleLab.labInit(textColor: .black, textPlace: .center, font: nFont)
//        firmTitleLab.layer.borderWidth = 1
//        firmTitleLab.layer.cornerRadius = 8
//        firmTitleLab.layer.borderColor = UIColor.systemBlue.cgColor
        contentView.addSubview(firmTitleLab)
        firmTitleLab.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(labSpace)
            make.bottom.equalToSuperview().offset(-labSpace)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-20)
        }
    }
}
