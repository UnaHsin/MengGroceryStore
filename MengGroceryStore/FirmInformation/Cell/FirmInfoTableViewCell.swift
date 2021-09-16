//
//  FirmInfoTableViewCell.swift
//  MengGroceryStore
//
//  Created by FESC on 2021/9/16.
//  Copyright © 2021 Una Lee. All rights reserved.
//

import UIKit

class FirmInfoTableViewCell: UITableViewCell {

    private let deviceScale = SystemInfo.getDeviceScale()
    
    // 商品 Barcode
    private lazy var firmVanNumberLab = UILabel()
    
    // 商品 名稱
    private lazy var firmNameLab = UILabel()
    

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
        
        // 廠商統一編號 設定
        firmVanNumberLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmVanNumberLab.text = "123456789"
        contentView.addSubview(firmVanNumberLab)
        firmVanNumberLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.3)
        }
        
        // 廠商名稱 設定
        firmNameLab.labInit(textColor: .black, textPlace: .left, font: aFont)
        firmNameLab.text = "老闆休息中"
        contentView.addSubview(firmNameLab)
        firmNameLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(firmVanNumberLab.snp.right)
        }
    }
    
    //控制器傳來的值
    internal func getInformation(_ vanNumber: String, _ name: String?) {
        firmVanNumberLab.text = vanNumber
        firmNameLab.text = name
    }

}
