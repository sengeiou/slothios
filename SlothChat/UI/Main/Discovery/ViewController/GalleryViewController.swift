//
//  GalleryViewController.swift
//  SlothChat
//
//  Created by fly on 2016/11/4.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

enum DisplayType: String {
    case newest = "newest"
    case hottest = "hottest"
}

private let PageSize = 20

class GalleryViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var displayType:DisplayType = .hottest
    
    var dataSource = [DisplayOrderPhoto]()
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var pageNum = 1
    
    var refreshUI = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if refreshUI {
            refreshUI = false
            tableView.mj_header.beginRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTableView()
        setupPullToRefresh()
        self.configNotice()
    }
    
    func configNotice() {
        NotificationCenter.default.addObserver(forName: SGGlobalKey.DiscoveryDataDidChange, object: nil, queue: OperationQueue.main, using: { (notice) in
            if self.isMyselfShow{
                self.tableView.mj_header.beginRefreshing()
            }else{
                self.refreshUI = true
            }
        })
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
        engine.getOrderGallery(likeSenderUserUuid: userUuid, displayType: displayType, pageNum: String(pageNum), pageSize: String(PageSize)) { (response) in
            if at == .top {
                self.tableView.mj_header.endRefreshing()
            }else{
                self.tableView.mj_footer.endRefreshing()
            }
            
            if response?.status == ResponseError.SUCCESS.0 {
                if let list = response?.data?.list{
                    self.tableView.mj_footer?.isHidden = (list.count < PageSize)
                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    self.dataSource.append(contentsOf: list)
                    self.tableView.reloadData()
                }
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func likeGallery(indexPath: IndexPath) {
        let photoObj = dataSource[indexPath.row]
        
        photoObj.currentVisitorLiked = !photoObj.currentVisitorLiked!
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
        
        let engine = NetworkEngine()

        let userUuid = Global.shared.globalProfile?.userUuid
        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj.uuid) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                
            }else{
                self.showNotificationError(message: response?.msg)
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
        let photoObj = dataSource[indexPath.row]
        
        if  photoObj.displayAsBidAds!{
            let pushVC = BrowseAdvertViewController()
            pushVC.configWithObject(photoObj: photoObj)
            self.navigationController?.pushViewController(pushVC, animated: true)
        }else{
            let browser = ImageScrollViewController()
            browser.photoObj = photoObj
            browser.disPlay(photoObj: photoObj)
            self.present(browser, animated: true, completion: nil)
        }
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

private extension GalleryViewController {
    
    func setupPullToRefresh() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.getOrderGallery(at: .top)
        })
        tableView.mj_header.isAutomaticallyChangeAlpha = true
        
        tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.getOrderGallery(at: .bottom)
        })
    }
}
