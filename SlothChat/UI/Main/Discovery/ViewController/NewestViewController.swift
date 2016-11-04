//
//  NewestViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

private let PageSize = 20

class NewestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [DisplayOrderPhoto]()
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var pageNum = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        setupPullToRefresh()
        getOrderGallery(at: .top)
    }
    
    func configTableView() {
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
    
    //MARK:- NetWork
    func getOrderGallery(at: Position) {
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        let engine = NetworkEngine()
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getOrderGallery(likeSenderUserUuid: userUuid, displayType: .newest, pageNum: String(pageNum), pageSize: String(PageSize)) { (displayOrder) in
            if at == .top {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            if displayOrder?.status == ResponseError.SUCCESS.0 {
                if let list = displayOrder?.data?.list{
                    self.tableView.mj_footer?.isHidden = (list.count < PageSize)
                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    self.dataSource.append(contentsOf: list)
                    self.tableView.reloadData()
                }
            }else{
                HUD.flash(.label("获取照片列表失败"), delay: 2)
            }
        }
    }
    
    func likeGallery(indexPath: IndexPath) {
        let photoObj = dataSource[indexPath.row]
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj.uuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                photoObj.currentVisitorLiked = true
                self.tableView.reloadData()
            }else{
                HUD.flash(.label("点赞失败"), delay: 2)
            }
        }
    }
    
    //MARK:- UITableViewDelegate,UITableViewDataSource,
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DiscoveryCell = tableView.dequeueReusableCell(withIdentifier: "DiscoveryCell", for: indexPath) as! DiscoveryCell
        let photoObj = dataSource[indexPath.row]
        cell.configCellWithObj(photoObj: photoObj)
        cell.indexPath = indexPath
        cell.setClosurePass { (actionType, actionIndexPath) in
            self.performCellAction(actionType: actionType, indexPath: actionIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pushVC = BrowseAdvertViewController()

        let photoObj = dataSource[indexPath.row]
        pushVC.configWithObject(photoObj: photoObj)
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func performCellAction(actionType: DiscoveryActionType, indexPath: IndexPath) {
        SGLog(message: actionType)
        SGLog(message: indexPath.row)
        
        switch actionType {
        case .likeType:
            likeGallery(indexPath: indexPath)
            break
        case .mainImgType:
            let actionPhotoObj = dataSource[indexPath.row]
            let browser = ImageScrollViewController()
            browser.photoObj = actionPhotoObj
            browser.disPlay(photoObj: actionPhotoObj)
            self.present(browser, animated: true, completion: nil)
            
            break
        case .likeUsersType:
            let actionPhotoObj = dataSource[indexPath.row]
            let pushVC = LikeUsersViewController()
            pushVC.galleryUuid = actionPhotoObj.uuid
            pushVC.likeSenderUserUuid = actionPhotoObj.userUuid
            navigationController?.pushViewController(pushVC, animated: true)
            break
        case .avatarType:
            let actionPhotoObj = dataSource[indexPath.row]
            let pushVC = UserInfoViewController()
            pushVC.mUserUuid = actionPhotoObj.userUuid
            
            let userUuid = Global.shared.globalProfile?.userUuid
            pushVC.likeSenderUserUuid = userUuid
            navigationController?.pushViewController(pushVC, animated: true)
            
            break
        }
        
    }
}

private extension NewestViewController {
    
    func setupPullToRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getOrderGallery(at: .top)
        })
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        
        tableView.mj_footer = MJRefreshFooter(refreshingBlock: {
            self.getOrderGallery(at: .bottom)
        })
    }
}
