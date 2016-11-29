//
//  OfficialGroupHeaderView.swift
//  SlothChat
//
//  Created by fly on 2016/11/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class OfficialGroupHeaderView: UICollectionReusableView {
    let flagImgView = UIImageView()
    let topicImgView = UIImageView()
    let flagLabel = UILabel()
    let topicTitle = UILabel()
    let expand = UIButton(type: .custom)
    
    var top1: ConstraintMakerFinalizable?
    var top2: ConstraintMakerFinalizable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(flagImgView)
        addSubview(topicImgView)
        addSubview(topicTitle)
        let line = UIView()
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        flagImgView.image = UIImage(named: "icon_setting")
        topicImgView.isHidden = true

        flagLabel.text = "请注意：本群只能发语音，每条语音30'后自动销毁。"
        flagLabel.font = UIFont.systemFont(ofSize: 12)
        flagLabel.textColor = SGColor.SGTextColor()
        addSubview(flagLabel)
        
        addSubview(expand)
        expand.setImage(UIImage(named: "go-back"), for: .normal)
        expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 3 / 2)
        expand.addTarget(self, action: #selector(expandClick), for: .touchUpInside)
        
        flagImgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(8)
            make.size.equalTo(CGSize.init(width: 24, height: 23))
        }
        
        topicTitle.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.right.equalTo(-32)
            make.left.equalTo(flagImgView.snp.right).offset(4)
        }
        
        expand.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.right.equalTo(-8)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }

        line.snp.makeConstraints { (make) in
            self.top1 = make.top.equalTo(topicTitle.snp.bottom).offset(8)
            self.top2 = make.top.equalTo(topicImgView.snp.bottom).offset(8)
            self.top2!.constraint.deactivate()
            
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        flagLabel.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
        
        topicImgView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(topicTitle.snp.bottom).offset(10)
            make.height.equalTo(240)
        }
    }
    
    func expandClick() {
        
        if topicTitle.numberOfLines == 0 {
            topicTitle.numberOfLines = 1
            topicTitle.lineBreakMode = .byTruncatingTail
            expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 3 / 2)
            topicImgView.isHidden = true
            flagLabel.isHidden = false
            self.top1!.constraint.activate()
            self.top2!.constraint.deactivate()
        }else{
            topicTitle.numberOfLines = 0
            topicTitle.lineBreakMode = .byCharWrapping
            expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
            topicImgView.isHidden = false
            flagLabel.isHidden = true
            self.top2!.constraint.activate()
            self.top1!.constraint.deactivate()
        }
    }
    
    func configViewWithObject(group: ChatOfficialGroupVo?) {
        guard let group = group,
            let topicPicUrl = group.topicPicUrl else {
                return
        }
        let avatarUrl = URL(string: topicPicUrl)
        topicImgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "placeHolder_offical.jpg"), options: nil, progressBlock: nil, completionHandler: nil)
        topicTitle.text = group.topicMsg
    }
}
