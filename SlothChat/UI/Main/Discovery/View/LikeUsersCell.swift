//
//  LikeUsersCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

typealias LikeUserClosureType = (_ indexPatch: IndexPath) -> Void

class LikeUsersCell: UITableViewCell {
    
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let browseButton = UIButton(type: .custom)
    
    var indexPath: IndexPath?
    
    var selectPassValue: LikeUserClosureType?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func sentupView() {
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(browseButton)
        
        avatarImgView.layer.cornerRadius = 18
        avatarImgView.layer.masksToBounds = true
        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
        nameLabel.font = UIFont.systemFont(ofSize: 15)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(18)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        browseButton.setTitle("查看", for: .normal)
        browseButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        browseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        browseButton.addTarget(self, action: #selector(browseButtonClick), for: .touchUpInside)
        browseButton.snp.makeConstraints { (make) in
            make.right.equalTo(0)
            make.width.equalTo(60)
            make.top.bottom.equalTo(0)
        }
    }
    
    func configCellWithObj(userObj: UserProfileData) {
        let photoObj = userObj.userPhotoList?.first
        if photoObj != nil && photoObj?.profileBigPicUrl != nil {
            let avatarUrl = URL(string: (photoObj?.profileBigPicUrl!)!)
            self.avatarImgView.kf.setImage(with: avatarUrl, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        self.nameLabel.text = userObj.nickname
    }
    
    func browseButtonClick() {
        if self.indexPath == nil {
            return
        }
        if let sp = self.selectPassValue {
            sp(self.indexPath!)
        }
    }
    
    func setClosurePass(temClosure: @escaping LikeUserClosureType){
        self.selectPassValue = temClosure
    }
}
