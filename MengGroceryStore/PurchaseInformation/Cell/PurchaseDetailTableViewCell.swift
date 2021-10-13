//
//  PurchaseDetailTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/4.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class PurchaseDetailTableViewCell: UITableViewCell {
    
    let deviceScale = SystemInfo.getDeviceScale()
    
    // 進貨條碼號碼
    private lazy var purchaseDetailItemBarcodeLab = UILabel()
    var purchaseDetailItemBarcodeStr: String? {
        didSet {
            purchaseDetailItemBarcodeLab.text = purchaseDetailItemBarcodeStr
        }
    }
    
    // 進貨商品 名稱
    private lazy var purchaseDetailItemNameLab = UILabel()
    var purchaseDetailItemNameStr: String? {
        didSet {
            purchaseDetailItemNameLab.text = purchaseDetailItemNameStr
        }
    }
    
    // 進貨商品 數量
    private lazy var purchaseDetailItemAmountLab = UILabel()
    var purchaseDetailItemAmountStr: String? {
        didSet {
            purchaseDetailItemAmountLab.text = purchaseDetailItemAmountStr
        }
    }
    
    // 進貨商品 單價
    private lazy var purchaseDetailItemPriceLab = UILabel()
    var purchaseDetailItemPriceStr: String? {
        didSet {
            purchaseDetailItemPriceLab.text = purchaseDetailItemPriceStr
        }
    }
    
    // 進貨商家
    private lazy var purchaseFirmNameLab = UILabel()
    var purchaseFirmNameStr: String? {
        didSet {
            purchaseFirmNameLab.text = purchaseFirmNameStr
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
        
        let allPurchaseInfoStack = UIStackView()
        allPurchaseInfoStack.spacing = 5
        allPurchaseInfoStack.distribution = .fillProportionally
        allPurchaseInfoStack.axis = .vertical
        contentView.addSubview(allPurchaseInfoStack)
        allPurchaseInfoStack.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(5)
            make.bottom.right.equalToSuperview().offset(-5)
        }
        
        // barCode number and name stack view
        let purchaseNameStack = UIStackView()
        purchaseNameStack.spacing = 5
        purchaseNameStack.distribution = .fillProportionally
        purchaseNameStack.axis = .horizontal
        allPurchaseInfoStack.addArrangedSubview(purchaseNameStack)
        
        // barCode number
        purchaseDetailItemBarcodeLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseNameStack.addArrangedSubview(purchaseDetailItemBarcodeLab)
        
        // name
        purchaseDetailItemNameLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseNameStack.addArrangedSubview(purchaseDetailItemNameLab)
        
        // 進貨數量 stack view
        let purchaseAmountStack = UIStackView()
        purchaseAmountStack.spacing = 5
        purchaseAmountStack.distribution = .fillProportionally
        purchaseAmountStack.axis = .horizontal
        allPurchaseInfoStack.addArrangedSubview(purchaseAmountStack)
        
        let purchaseAmountTipLab = UILabel()
        purchaseAmountTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        purchaseAmountTipLab.text = "進貨數量:"
        purchaseAmountStack.addArrangedSubview(purchaseAmountTipLab)
        
        purchaseDetailItemAmountLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseAmountStack.addArrangedSubview(purchaseDetailItemAmountLab)
        
        // 進貨單價 stack view
        let purchasePriceStack = UIStackView()
        purchasePriceStack.spacing = 5
        purchasePriceStack.distribution = .fillProportionally
        purchasePriceStack.axis = .horizontal
        allPurchaseInfoStack.addArrangedSubview(purchasePriceStack)
        
        let purchasePriceTipLab = UILabel()
        purchasePriceTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        purchasePriceTipLab.text = "進貨單價:"
        purchasePriceStack.addArrangedSubview(purchasePriceTipLab)
        
        purchaseDetailItemPriceLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchasePriceStack.addArrangedSubview(purchaseDetailItemPriceLab)
        
        // 進貨店家 stack view
        let purchaseFirmStack = UIStackView()
        purchaseFirmStack.spacing = 5
        purchaseFirmStack.distribution = .fillProportionally
        purchaseFirmStack.axis = .horizontal
        allPurchaseInfoStack.addArrangedSubview(purchaseFirmStack)
        
        let purchaseFirmNameTipLab = UILabel()
        purchaseFirmNameTipLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        purchaseFirmNameTipLab.text = "進貨店家:"
        purchaseFirmStack.addArrangedSubview(purchaseFirmNameTipLab)
        
        purchaseFirmNameLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseFirmStack.addArrangedSubview(purchaseFirmNameLab)
    }
}
