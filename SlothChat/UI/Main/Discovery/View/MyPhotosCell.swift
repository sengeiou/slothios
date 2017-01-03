//
//  MyPhotosCell.swift
//  Project05MyPhotos
//
//  Created by fly on 6/8/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit
import SDWebImage

class MyPhotosCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    let flagView = FlagView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sentupView()
    }
    
    func sentupView()  {
        self.clipsToBounds = true
        imgView.frame = self.bounds
        contentView.addSubview(imgView)
        imgView.contentMode = .scaleAspectFill
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        flagView.isHidden = true
        contentView.addSubview(flagView)
        flagView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.right.equalTo(-6)
            make.height.equalTo(22)
//            make.size.equalTo(CGSize.init(width: 45, height: 22))
        }
    }
    
    func isShowFlagView(isShow: Bool) {
        flagView.isHidden = !isShow
    }
    
    func configCellObject(photo: UserGalleryPhoto) {
        if photo.smallPicUrl != nil {
            let url = URL(string: photo.smallPicUrl!)
            imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon"))
        }
        flagView.isHidden = true
        flagView.setIsDisplayAsBidAds(displayAsBidAds: photo.displayAsBidAds!)
        flagView.setIsParticipateBidAds(participateBidAds: photo.participateBidAds!)
    }
    
    func configCellObject(chatUser: ChatMemberInfo) {
        if chatUser.profilePicUrl != nil {
            let url = URL(string: chatUser.profilePicUrl!)
            imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon"))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
