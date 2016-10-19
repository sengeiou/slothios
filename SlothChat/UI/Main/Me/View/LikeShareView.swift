//
//  LikeShareView.swift
//  SlothChat
//
//  Created by fly on 2016/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SnapKit

class LikeShareView: BaseView {
    let imgView = UIImageView()
    let likeLabel = UILabel()
    let shareButton = UIButton(type: .custom)
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    init(type : InputType){
        self.init()
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sentupView() {
        addSubview(imgView)
        likeLabel.text = "0人喜欢"
        addSubview(likeLabel)
        addSubview(shareButton)
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 16, height: 16))
        }
        
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(4)
            make.centerY.equalTo(self.snp.centerY)
        }
        
        shareButton.snp.makeConstraints { (make) in
            make.left.equalTo(likeLabel.snp.right).offset(4)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 44, height: 44))
        }
    }
    
    func configLikeLabel(count: Int) {
        likeLabel.text = String(count) + "人喜欢"
    }
    
}
