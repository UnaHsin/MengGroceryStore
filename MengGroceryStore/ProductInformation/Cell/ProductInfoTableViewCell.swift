//
//  ProductInfoTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/7.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ProductInfoTableViewCell: UITableViewCell {
    
    private let deviceScale = SystemInfo.getDeviceScale()
    
    // 商品 Barcode
    private lazy var productBarcodeLab = UILabel()
    
    // 商品 名稱
    private lazy var productNameLab = UILabel()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        //創建UI
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCell() {
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        
        // 商品條碼數字 設定
        productBarcodeLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productBarcodeLab.text = "123456789"
        contentView.addSubview(productBarcodeLab)
        productBarcodeLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.4)
        }
        
        // 商品名稱 設定
        productNameLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        productNameLab.text = "老闆休息中"
        contentView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(productBarcodeLab.snp.right).offset(15)
        }
    }
    
    //控制器傳來的值
    internal func getInformation(_ barcode: String, _ name: String?) {
        productBarcodeLab.text = barcode
        productNameLab.text = name
    }

}
