//
//  LikeUsersView.swift
//  SlothChat
//
//  Created by Fly on 16/4/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit


class LikeUserCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sentupView()
    }
    
    func sentupView()  {
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 15
        
        imgView.frame = self.bounds
        self.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func configViewWithObject(imgUrl: String) {
        let url = URL(string: imgUrl)
        imgView.sd_setImage(with: url, placeholderImage: UIImage(named: "icon"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LikeUsersView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let countLabel = UILabel()
    
    let bgImgView = UIImageView.init()
    var dataSource = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshItemSize(width:Int,height:Int) {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize.init(width: width, height: height)
        self.collectionView?.reloadData()
    }
    
    fileprivate func sentupView() {
        let frame = CGRect.zero
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize.init(width: 30, height: 30)
        
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 9, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 9;
        
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.register(LikeUserCell.self, forCellWithReuseIdentifier: "LikeUserCell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.addSubview(collectionView!)
        
        collectionView!.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.right.equalTo(-70)
        }
        collectionView!.isUserInteractionEnabled = false
        
        countLabel.font = UIFont.systemFont(ofSize: 11)
        self.addSubview(countLabel)
        countLabel.snp.makeConstraints { (make) in
            make.left.equalTo(4)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : LikeUserCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LikeUserCell", for: indexPath as IndexPath) as! LikeUserCell
        let imgUrl = dataSource[indexPath.row ]
        cell.configViewWithObject(imgUrl: imgUrl)

        
        return cell
    }
    
    func configViewWithObject(avatarList: [String]?, totalCount: Int) {
        if avatarList != nil{
            dataSource.removeAll()
            
            if totalCount <= 0 {
                countLabel.text = " "
                countLabel.snp.updateConstraints { (make) in
                    make.left.equalTo(9)
                }
                collectionView?.isHidden = true
            }else{
                collectionView?.isHidden = false
                dataSource.append(contentsOf: avatarList!)
                collectionView?.reloadData()
                
                let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
                countLabel.text = "等" + String(totalCount) + "人喜欢"
                let width = layout.itemSize.width
                
                let count = avatarList!.count
                countLabel.snp.updateConstraints { (make) in
                    make.left.equalTo((9 + Int(width)) * count + 10)
                }
            }
        }
    }
}


