//
//  PurchaseHistoryListTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/10/1.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class PurchaseHistoryListTableViewCell: UITableViewCell {

    let deviceScale = SystemInfo.getDeviceScale()
    
    // 進貨排序
    private lazy var purchaseHistoryItemNoLab = UILabel()
    var purchaseHistoryItemNoStr: String? {
        didSet {
            purchaseHistoryItemNoLab.text = purchaseHistoryItemNoStr
        }
    }
    
    // 進貨序號
    private lazy var purchaseHistoryNumberLab = UILabel()
    var purchaseHistoryNumberStr: String? {
        didSet {
            purchaseHistoryNumberLab.text = purchaseHistoryNumberStr
        }
    }
    
    // 進貨時間
    private lazy var purchaseHistoryTimeLab = UILabel()
    var purchaseHistoryTimeStr: String? {
        didSet {
            let finalShowTime = String(purchaseHistoryTimeStr!.prefix(10))
            purchaseHistoryTimeLab.text = finalShowTime
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
        
        purchaseHistoryItemNoLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        contentView.addSubview(purchaseHistoryItemNoLab)
        purchaseHistoryItemNoLab.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.1)
        }
        
        let purchaseInfoStack = UIStackView()
        purchaseInfoStack.spacing = 5
        purchaseInfoStack.distribution = .fillProportionally
        purchaseInfoStack.axis = .horizontal
        contentView.addSubview(purchaseInfoStack)
        purchaseInfoStack.snp.makeConstraints { make in
            make.centerY.equalTo(purchaseHistoryItemNoLab)
            make.left.equalTo(purchaseHistoryItemNoLab.snp.right).offset(15 * deviceScale)
            make.right.equalToSuperview().offset(-10)
        }
        
        purchaseHistoryNumberLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseInfoStack.addArrangedSubview(purchaseHistoryNumberLab)
        
        purchaseHistoryTimeLab.labInit(textColor: .black, textPlace: .center, font: aFont)
        purchaseInfoStack.addArrangedSubview(purchaseHistoryTimeLab)
    }


}
