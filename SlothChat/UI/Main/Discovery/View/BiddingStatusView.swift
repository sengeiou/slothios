//
//  BiddingStatusView.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

enum  BiddingStatus: Int{
    case bidding
    case bidded
}

class BiddingStatusView: BaseView {
    let mainImgView = UIImageView()
    
    let selectButton = UIButton(type: .custom)
    
    let usersView = LikeUsersView()
    
    let priceView = UIView()
    let priceLabel = UILabel()
    let overweightButton = UIButton(type: .custom)

    let timeoutLabel = UILabel()
    
    let pickerView = ValuePickerView.init()
    
    var selectPassValue: PublishAdvertClosureType?
    var bidstatus: BiddingStatus = .bidding
    var price = 1{
        didSet{
          configPriceLabel()
        }
    }
    
    init(frame: CGRect,status: BiddingStatus) {
        super.init(frame: frame)
        sentupView()
        
        if status == .bidded {
            timeoutLabel.isHidden = false
            overweightButton.isEnabled = false
            overweightButton.backgroundColor = SGColor.SGBgGrayColor()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        
        addSubview(mainImgView)
        
        addSubview(usersView)
        
        
        mainImgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(256)
        }
        
        usersView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(mainImgView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }

        addSubview(priceView)
        priceView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(usersView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        configPriceView()
        configPickerView()
    }
    
    func configPriceView() {
        
        configPriceLabel()
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceView.addSubview(priceLabel)
        
        overweightButton.addTarget(self, action: #selector(overweightButtonClick), for: .touchUpInside)
        
        overweightButton.setTitle("加码", for: .normal)
        overweightButton.setTitleColor(UIColor.white, for: .normal)
        overweightButton.backgroundColor = SGColor.SGMainColor()
        overweightButton.layer.cornerRadius = 20
        priceView.addSubview(overweightButton)
        
        timeoutLabel.text = "竞价时间结束"
        timeoutLabel.textColor = SGColor.SGTextColor()
        timeoutLabel.font = UIFont.systemFont(ofSize: 12)
        priceView.addSubview(timeoutLabel)
        timeoutLabel.isHidden = true
        
        priceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(priceView.snp.centerY)
        }
        
        overweightButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(priceView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 64, height: 40))
        }
        
        timeoutLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.top.equalTo(overweightButton.snp.bottom).offset(10)
        }        
    }
    
    func configPriceLabel() {
        let string1 = "当前竞价额    "
        let string2 = "￥" + String(price)
        let attributedText = NSMutableAttributedString.init(string: string1 + string2)
        
        let range = NSRange.init(location: string1.characters.count, length: string2.characters.count)
        attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGBlueColor(), range: range)
        attributedText.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 15), range: range)
        priceLabel.attributedText = attributedText
    }
    
    func configPickerView() {
        pickerView.pickerTitle = "加码金额"
        let completionBlock: (String?) -> Void = {(_ value: String?) in
            SGLog(message: value)
            
            self.price += Int(value!.components(separatedBy: "/").first!)!
        }
        pickerView.valueDidSelect = completionBlock
        pickerView.dataSource = ["1","5","10","50","100","500","1000"]
    }
    
    //MARK:- Action
    
    func selectButtonCLick() {
        selectButton.isSelected = !selectButton.isSelected
        priceView.isHidden = !selectButton.isSelected
        
        if selectButton.isSelected {
            selectButton.setBackgroundImage(UIImage.init(named: "selyes"), for: .highlighted)
        }else{
            selectButton.setBackgroundImage(UIImage.init(named: "selno"), for: .highlighted)
        }
        
        if let sp = self.selectPassValue {
            sp()
        }
    }
    
    func configWithObject(imgUrl: String) {
        
        let avatarUrl = URL(string: imgUrl)
        self.mainImgView.kf.setImage(with: avatarUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        
        let userObj = UserObj.defaultUserObj()
        usersView.configViewWithObject(avatarList: userObj.avatarList)
        
    }
    
    func overweightButtonClick() {
        pickerView.show()
    }
}