//
//  LikeShareView.swift
//  SlothChat
//
//  Created by fly on 2016/10/19.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SnapKit

typealias LikeUserListType = () -> Void

class LikeShareView: BaseView {
    let imgView = UIImageView()
    let likeLabel = UILabel()
    let shareButton = UIButton(type: .custom)
    let sharePopView = SGSharePopView()
    
    var actionInfoValue:LikeUserListType?

    
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
        imgView.image = UIImage.init(named: "heart-solid")
        addSubview(imgView)
        likeLabel.text = "0人喜欢"
        addSubview(likeLabel)
        addSubview(shareButton)
        imgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 12, height: 12))
        }
        
        likeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(imgView.snp.right).offset(4)
            make.centerY.equalTo(self.snp.centerY)
        }
        shareButton.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
        shareButton.setImage(UIImage.init(named: "share"), for: .normal)
        shareButton.snp.makeConstraints { (make) in
            make.left.equalTo(likeLabel.snp.right).offset(19)
            make.centerY.equalTo(self.snp.centerY)
            make.size.equalTo(CGSize.init(width: 24, height: 24))
        }
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(likeUserTap))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap1)
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(likeUserTap))
        likeLabel.isUserInteractionEnabled = true
        likeLabel.addGestureRecognizer(tap2)
        
        let tmpApp = UIApplication.shared.delegate as! AppDelegate;
        if let window = tmpApp.window{
            window.addSubview(sharePopView)
            sharePopView.isHidden = true
            sharePopView.snp.makeConstraints({ (make) in
                make.edges.equalTo(UIEdgeInsets.zero)
            })
        }
    }
    
    func configLikeLabel(count: Int) {
        likeLabel.text = String(count) + "人喜欢"
    }
    
    func setActionInfoValue(temClosure: @escaping LikeUserListType){
        self.actionInfoValue = temClosure
    }
    
    func likeUserTap() {
        SGLog(message: "")
        if let sp = self.actionInfoValue {
            sp()
        }
    }
    
    func shareButtonClick() {
        SGLog(message: "")
        sharePopView.isHidden = false
    }
    
}
