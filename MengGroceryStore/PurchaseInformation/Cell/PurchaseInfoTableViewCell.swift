//
//  PurchaseInfoTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/23.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class PurchaseInfoTableViewCell: UITableViewCell {
    let deviceScale = SystemInfo.getDeviceScale()
    
    // 商品排序
    private lazy var productItemNoLab = UILabel()
    var productItemNoStr: String? {
        didSet {
            productItemNoLab.text = productItemNoStr
        }
    }
    
    // 商品名稱
    private lazy var productNameLab = UILabel()
    var productnameStr: String? {
        didSet {
            productNameLab.text = productnameStr
        }
    }
    
    // 商品總進價
    private lazy var productAllPriceLab = UILabel()
    var productAllPriceStr: String? {
        didSet {
            productAllPriceLab.text = productAllPriceStr
        }
    }
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
         
        //創建UI
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //初始化
    func setupCell() {
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        
        productItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        contentView.addSubview(productItemNoLab)
        productItemNoLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        productNameLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        contentView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { make in
            make.centerY.equalTo(productItemNoLab)
            make.left.equalTo(productItemNoLab.snp.right).offset(15 * deviceScale)
        }
        
        productAllPriceLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        contentView.addSubview(productAllPriceLab)
        productAllPriceLab.snp.makeConstraints { make in
            make.centerY.equalTo(productItemNoLab)
            make.right.equalToSuperview().offset(-10)
            make.left.equalTo(productNameLab.snp.right).offset(-15 * deviceScale)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }

}
