//
//  MyPhotosViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import Kingfisher

class MyPhotosViewController: BaseViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    let bgImgView = UIImageView.init()
    var dataSource = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let avatarList = [
            "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
            "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
            "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg",
            ]

        dataSource.append(contentsOf: avatarList)
        
        self.configCollectionView()
    }

    
    func configCollectionView() {
        let frame = CGRect.zero
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        
        let screenWidth = UIScreen.main.bounds.width
        let width = (screenWidth - 10 * 4) / 3.0
        layout.itemSize = CGSize.init(width: width, height: width)
        
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10);
        layout.minimumLineSpacing = 10;
        
        let collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(MyPhotosCell.self, forCellWithReuseIdentifier: "MyPhotosCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (dataSource.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : MyPhotosCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyPhotosCell", for: indexPath as IndexPath) as! MyPhotosCell
        
        if indexPath.row == 0 {
            cell.imgView.contentMode = .redraw
            cell.imgView.image = UIImage.init(named: "select_photoBg")
            return cell
        }
        cell.imgView.contentMode = .scaleAspectFit

        let imgUrl = dataSource[indexPath.row - 1]
        
        let url = URL(string: imgUrl)
        cell.imgView.kf.setImage(with: url, placeholder: UIImage.init(named: "icon"), options: nil, progressBlock: nil, completionHandler: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            UIActionSheet.photoPicker(withTitle: nil, showIn: self.view, presentVC: self, onPhotoPicked: { (avatar) in
                self.publishAdvert(image: avatar!)
                }, onCancel:nil)
            return
        }
        let imgUrl = dataSource[indexPath.row - 1]
        let pushVC = BiddingStatusViewController()
        pushVC.configWithObject(imgUrl: imgUrl)
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func publishAdvert(image: UIImage) {
        let pushVC = PublishViewController()
        pushVC.configWithObject(image: image)
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
}

