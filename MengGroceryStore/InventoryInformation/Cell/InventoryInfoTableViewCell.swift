//
//  InventoryInfoTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/10.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class InventoryInfoTableViewCell: UITableViewCell {
    let deviceScale = SystemInfo.getDeviceScale()
    
    // 商品排序
    private lazy var productItemNoLab = UILabel()
    var productItemNoStr: String? {
        didSet {
            productItemNoLab.text = productItemNoStr
        }
    }
    
    // 商品 Barcode
    private lazy var productBarcodeLab = UILabel()
    var productBarcodeStr: String? {
        didSet {
            productBarcodeLab.text = productBarcodeStr
        }
    }
    
    // 商品名稱
    private lazy var productNameLab = UILabel()
    var productNameStr: String? {
        didSet {
            productNameLab.text = productNameStr
        }
    }
    
    // 商品庫存總數
    private lazy var productInventoryAmountLab = UILabel()
    var productInventoryAmounStr: String? {
        didSet {
            productInventoryAmountLab.text = productInventoryAmounStr
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
        
        productItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        contentView.addSubview(productItemNoLab)
        productItemNoLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        let productInfoStack = UIStackView()
        productInfoStack.spacing = 5
        productInfoStack.distribution = .fillProportionally
        productInfoStack.axis = .vertical
        contentView.addSubview(productInfoStack)
        productInfoStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().offset(-5)
            make.left.equalTo(productItemNoLab.snp.right)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        productBarcodeLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        productInfoStack.addArrangedSubview(productBarcodeLab)
        
        productNameLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        productInfoStack.addArrangedSubview(productNameLab)
        
        // 庫存數量
        productInventoryAmountLab.labInit(textColor: .black, textPlace: .right, font: aFont)
        contentView.addSubview(productInventoryAmountLab)
        productInventoryAmountLab.snp.makeConstraints { make in
            make.centerY.equalTo(productItemNoLab)
            make.left.equalTo(productInfoStack.snp.right)
            make.width.equalToSuperview().multipliedBy(0.15)
        }
    }

}
