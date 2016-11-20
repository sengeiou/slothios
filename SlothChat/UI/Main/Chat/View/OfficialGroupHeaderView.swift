//
//  OfficialGroupHeaderView.swift
//  SlothChat
//
//  Created by fly on 2016/11/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class OfficialGroupHeaderView: UICollectionReusableView {
    let imgView = UIImageView()
    let title = UILabel()
    let expand = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(imgView)
        addSubview(title)
        let line = UIView()
        line.backgroundColor = SGColor.SGLineColor()
        addSubview(line)
        
        let flag = UILabel()
        flag.text = "请注意：本群只能发语音，每条语音30'后自动销毁。"
        flag.font = UIFont.systemFont(ofSize: 12)
        flag.textColor = SGColor.SGTextColor()
        addSubview(flag)
        
        addSubview(expand)
        expand.setImage(UIImage(named: "go-back"), for: .normal)
        expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 3 / 2)
        expand.addTarget(self, action: #selector(expandClick), for: .touchUpInside)
        
        imgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(8)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
        title.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.right.equalTo(-32)
            make.left.equalTo(imgView.snp.right).offset(4)
        }
        
        expand.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.right.equalTo(-8)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
        line.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.left.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        flag.snp.makeConstraints { (make) in
            make.top.equalTo(line.snp.bottom).offset(8)
            make.centerX.equalTo(self.snp.centerX)
        }
    }
    
    func expandClick() {
        
        if title.numberOfLines == 0 {
            title.numberOfLines = 1
            title.lineBreakMode = .byTruncatingTail
            expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi * 3 / 2)
        }else{
            title.numberOfLines = 0
            title.lineBreakMode = .byCharWrapping
            expand.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
        }
    }
    
    func configViewWithObject(group: ChatOfficialGroupVo?) {
        guard let group = group,
            let topicPicUrl = group.topicPicUrl else {
                return
        }
        let avatarUrl = URL(string: topicPicUrl)
        imgView.kf.setImage(with: avatarUrl, placeholder: UIImage(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        title.text = group.topicMsg
    }
}
