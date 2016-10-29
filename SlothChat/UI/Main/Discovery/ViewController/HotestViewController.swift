//
//  HotestViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class HotestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate {
    let dataSource = DiscoveryUserObj.getDiscoveryUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var photoList = [MWPhoto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        
        let w = UIScreen.main.bounds.width
        let imgViewHeight = (w * 200.0) / 375.0

        tableView.rowHeight = 145 + imgViewHeight

        view.addSubview(tableView)
        tableView.register(DiscoveryCell.self, forCellReuseIdentifier: "DiscoveryCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
    }
    //MARK:- UITableViewDelegate,UITableViewDataSource,
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DiscoveryCell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoveryCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        cell.indexPath = indexPath
        cell.setClosurePass { (actionType, actionIndexPath) in
            self.performCellAction(actionType: actionType, indexPath: actionIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func performCellAction(actionType: DiscoveryActionType, indexPath: IndexPath) {
        SGLog(message: actionType)
        SGLog(message: indexPath.row)

        switch actionType {
        case .likeType:
            
            break
        case .mainImgType:
            
            let userObj = dataSource[indexPath.row]
            let photoUrl = URL.init(string: userObj.mainImgUrl)
            let photo = MWPhoto(url: photoUrl)
            
            photoList.append(photo!)
            
            let browser = MWPhotoBrowser(delegate: self)
            self.navigationController?.pushViewController(browser!, animated: true)
            break
        case .likeUsersType:
            let pushVC = LikeUsersViewController()
            navigationController?.pushViewController(pushVC, animated: true)
            break
        }
    }
    
    //MARK:- MWPhotoBrowserDelegate

    func numberOfPhotos(in photoBrowser: MWPhotoBrowser!) -> UInt {
        return UInt(photoList.count)
    }
    
    func photoBrowser(_ photoBrowser: MWPhotoBrowser!, photoAt index: UInt) -> MWPhotoProtocol! {
        if (index < UInt(photoList.count)) {
            return photoList[Int(index)]
        }
        return nil;
    }
    
}
