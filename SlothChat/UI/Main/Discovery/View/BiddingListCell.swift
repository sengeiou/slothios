//
//  BiddingListCell.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import SDWebImage

class BiddingListCell: UITableViewCell {
    
    let rankLabel = UILabel()
    let avatarImgView = UIImageView()
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        self.contentView.addSubview(rankLabel)
        self.contentView.addSubview(avatarImgView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceLabel)

        rankLabel.font = UIFont.systemFont(ofSize: 14)
        rankLabel.textColor = SGColor.SGTextColor()
        
        
        avatarImgView.layer.cornerRadius = 18
        avatarImgView.layer.masksToBounds = true
        
        rankLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }

        avatarImgView.snp.makeConstraints { (make) in
            make.left.equalTo(rankLabel.snp.right).offset(10)
            make.centerY.equalTo(self.contentView.snp.centerY)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        }
        
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarImgView.snp.right).offset(20)
            make.centerY.equalTo(self.contentView.snp.centerY)
        }
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(-8)
            make.top.bottom.equalTo(0)
        }
    }
    
    func configCellWithObj(rankVo: BidAdsRankVo, indexPatch: IndexPath) {
        if let imgUrl = rankVo.profilePicUrl {
            let avatarUrl = URL(string: imgUrl)
            self.avatarImgView.sd_setImage(with: avatarUrl, placeholderImage: UIImage(named: "icon"))
        }
        if let rank = rankVo.rank {
            self.rankLabel.text = String(rank)
        }
        self.nameLabel.text = rankVo.nickname
        self.priceLabel.text =  "￥" + String(rankVo.bidTotalAmount!)
        
        if rankVo.visitorMyself! == true {
            self.backgroundColor = SGColor.SGMainColor().withAlphaComponent(0.4)
        } else {
            self.backgroundColor = SGColor.white
        }
    }
    
//    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
//        super.setHighlighted(highlighted, animated: animated)
//        if highlighted {
//            self.contentView.backgroundColor = SGColor.SGMainColor()
//        }else{
//            self.contentView.backgroundColor = UIColor.white
//        }
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected {
//            self.contentView.backgroundColor = SGColor.SGMainColor()
//        }else{
//            self.contentView.backgroundColor = UIColor.white
//        }
//    }

}
