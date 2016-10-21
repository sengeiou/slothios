//
//  SexButtonView.swift
//  SlothChat
//
//  Created by Fly on 16/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SnapKit

enum SGGenderType: Int {
    case male = 0
    case female = 1
}

class SexPickView: BaseView {
    let maleView = SexButtonView(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44), isMale: true)
    let femaleView = SexButtonView(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44), isMale: false)
    
    var isMalePick = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    init(frame: CGRect, isMale: Bool) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sentupView() {
        addSubview(maleView)
        addSubview(femaleView)
        maleView.button.addTarget(self, action: #selector(maleButtonClick), for: .touchUpInside)
        femaleView.button.addTarget(self, action: #selector(femaleButtonClick), for: .touchUpInside)

        maleView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
        
        femaleView.snp.makeConstraints { (make) in
            make.left.equalTo(maleView.snp.right).offset(10)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
    }
    
    func selectSexView(isMale: Bool) {
        isMalePick = isMale
        
        maleView.isSelectedStatus(isSelected: isMale)
        femaleView.isSelectedStatus(isSelected: !isMale)
    }
    
    func maleButtonClick() {
        selectSexView(isMale: true)
    }
    
    func femaleButtonClick() {
        selectSexView(isMale: false)
    }
}

class SexButtonView: BaseView {
    let sexImgView = UIImageView()
    let button = UIButton(type: .custom)
    var isChecked = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView(isMale: false)
    }
    
    init(frame: CGRect, isMale: Bool) {
        super.init(frame: frame)
        sentupView(isMale: isMale)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func sentupView(isMale: Bool) {
        let imgName = (isMale ? "male" : "female")
        sexImgView.image = UIImage.init(named: imgName)
        addSubview(sexImgView)
        
        addSubview(button)
        
        sexImgView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        layer.cornerRadius = (frame.width / 2.0)
        
    }
    
    func isSelectedStatus(isSelected: Bool) {
        isChecked = isSelected
        if isSelected {
            layer.borderColor = SGColor.SGMainColor().cgColor;
            layer.borderWidth = 1.0
        }else{
            layer.borderColor = UIColor.clear.cgColor;
            layer.borderWidth = 1.0
        }
    }

}
