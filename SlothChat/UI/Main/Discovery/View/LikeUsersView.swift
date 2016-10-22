//
//  LikeUsersView.swift
//  SlothChat
//
//  Created by Fly on 16/4/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class LikeUsersView: BaseView,UICollectionViewDelegate,UICollectionViewDataSource {
    var collectionView: UICollectionView?
    let countLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let bgImgView = UIImageView.init()
    var dataSource = [String]()
    
    func sentupView() {
        let frame = CGRect.zero
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize.init(width: 24, height: 24)
        
        layout.sectionInset = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4);
        layout.minimumLineSpacing = 4;
        
        
        collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView!.backgroundColor = UIColor.clear
        collectionView!.register(MyPhotosCell.self, forCellWithReuseIdentifier: "MyPhotosCell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        self.addSubview(collectionView!)
        
        collectionView!.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
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
        let cell : MyPhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotosCell", for: indexPath as IndexPath) as! MyPhotosCell
        let imgUrl = dataSource[indexPath.row ]
        
        let url = URL(string: imgUrl)
        cell.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func configViewWithObject(userObj: DiscoveryUserObj) {
        
        dataSource.removeAll()
        let count = userObj.likeUserList.count
        
        if count > 0 {
            dataSource.append(contentsOf: userObj.likeUserList)
        }
        collectionView?.reloadData()
        countLabel.text = "等" + String(count) + "人喜欢"
        countLabel.snp.updateConstraints { (make) in
            make.left.equalTo((4 + 24) * count + 4)
        }
    }
}

