//
//  ShoppinCarTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/13.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class ShoppinCarTableViewCell: UITableViewCell {
    let deviceScale = SystemInfo.getDeviceScale()
    
    // 商品名稱
    private lazy var productNameLab = UILabel()
    var productnameStr: String? {
        didSet {
            productNameLab.text = productnameStr
        }
    }
    
    // 商品數量
    private lazy var productItemAmountLab = UILabel()
    var productItemAmountStr: String? {
        didSet {
            productItemAmountLab.text = productItemAmountStr
        }
    }
    // 商品總進價
    private lazy var productAllPriceLab = UILabel()
    var productAllPriceStr: String? {
        didSet {
            productAllPriceLab.text = productAllPriceStr
        }
    }

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
    
    //初始化
    func setupCell() {
        let aFont = UIFont.systemFont(ofSize: 17 * deviceScale)
        
        productNameLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        contentView.addSubview(productNameLab)
        productNameLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        productItemAmountLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        contentView.addSubview(productItemAmountLab)
        productItemAmountLab.snp.makeConstraints { make in
            make.centerY.equalTo(productNameLab)
            make.left.equalTo(productNameLab.snp.right).offset(5)
            make.width.equalToSuperview().multipliedBy(0.13)
        }
        
        productAllPriceLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        contentView.addSubview(productAllPriceLab)
        productAllPriceLab.snp.makeConstraints { make in
            make.centerY.equalTo(productNameLab)
            make.right.equalToSuperview().offset(-10)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
    }

}
