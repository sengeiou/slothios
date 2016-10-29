//
//  MyPhotosCell.swift
//  Project05MyPhotos
//
//  Created by fly on 6/8/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit

class MyPhotosCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    let flagView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sentupView()
    }
    
    func sentupView()  {
        self.clipsToBounds = true
        imgView.frame = self.bounds
        contentView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        flagView.layer.borderColor = UIColor.white.cgColor
        flagView.layer.borderWidth = 1.0
        flagView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        contentView.addSubview(flagView)
        flagView.snp.makeConstraints { (make) in
            make.top.equalTo(6)
            make.right.equalTo(-6)
            make.size.equalTo(CGSize.init(width: 45, height: 22))
        }
        
        let label = UILabel()
        flagView.addSubview(label)
        label.text = "推荐"
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(flagView)
        }
    }
    
    func isShowFlagView(isShow: Bool) {
        flagView.isHidden = !isShow
    }
    
    func configViewObject(imgUrl: String) {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
