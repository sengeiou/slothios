//
//  PublishHeaderView.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class PublishHeaderView: BaseView {
    let mainImgView = UIImageView()
    
    let selectButton = UIButton(type: .system)
    
    let contentLabel = UILabel()
    
    var isFollow = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        
        addSubview(mainImgView)
        addSubview(contentLabel)
        
        let biddingView = UIView()
        addSubview(biddingView)
        
        let biddingLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 15)

        biddingLabel.text = "是否用此图片参与广告竞价"
        biddingLabel.textColor = SGColor.SGTextColor()
        biddingView.addSubview(biddingLabel)
        
        selectButton.adjustsImageWhenHighlighted = false
        selectButton.setImage(UIImage.init(named: "selno"), for: .normal)
        selectButton.setImage(UIImage.init(named: "selyes"), for: .selected)
        selectButton.addTarget(self, action: #selector(selectButtonCLick), for: .touchUpInside)
        addSubview(selectButton)
        
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        let w = UIScreen.main.bounds.width
        contentLabel.preferredMaxLayoutWidth = w - 8 * 2
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = SGColor.SGTextColor()
        contentLabel.text = "什么是广告位\n您可以支付一定金额参与图片的广告位竞价。若在截止时间您出价最高，则竞价成功。您将获得图片分享首页广告位一周时间。"
        
        mainImgView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(300)
        }
        
        biddingView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(mainImgView.snp.bottom).offset(24)
            make.height.equalTo(44)
        }
        
        biddingLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(biddingView.snp.centerY)
        }
        
        selectButton.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.centerY.equalTo(biddingView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 70, height: 40))
        }
        
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.top.equalTo(biddingView.snp.bottom).offset(24)
        }
        
        snp.makeConstraints { (make) in
            make.bottom.equalTo(contentLabel.snp.bottom).offset(20)
        }
    }
    
    func selectButtonCLick() {
        selectButton.isSelected = !selectButton.isSelected
    }
    
    func configWithObject(image: UIImage) {
        
        self.mainImgView.image = image
    }

}
