//
//  LikeUsersViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

private let PageSize = 20

class LikeUsersViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [LikeProfileListUser]()
    var likeSenderUserUuid: String?
    var galleryUuid: String?
    var isLikeMeUsers = false
    
    
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var pageNum = 1

    deinit {
        tableView.removePullToRefresh(tableView.bottomPullToRefresh!)
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "喜欢的人"
        sentupView()
        setupPullToRefresh()
        getLikeUserList(at: .top)
    }
    
    func getLikeUserList(at: Position) {
        if isLikeMeUsers{
            getLikeProfileList(at: .top)
        }else{
            getLikeGalleryList(at: .top)
        }
    }
    
    //MARK:- NetWork
    
    func getLikeGalleryList(at: Position) {
        if galleryUuid == nil || likeSenderUserUuid == nil{
            return
        }
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        
        let engine = NetworkEngine()

        engine.getLikeGalleryList(likeSenderUserUuid: likeSenderUserUuid, galleryUuid: galleryUuid!, pageNum: String(pageNum), pageSize: String(PageSize)) { (profileResult) in

            if at == .top {
                self.tableView.endRefreshing(at: .top)
            }else{
                self.tableView.endRefreshing(at: .bottom)
            }
            if profileResult?.status == ResponseError.SUCCESS.0 {
                if let list = profileResult?.data?.list{
                    self.tableView.bottomPullToRefresh?.refreshView.isHidden = (list.count < PageSize)
                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    self.dataSource.append(contentsOf: list)
                    self.tableView.reloadData()
                }
            }else{
                HUD.flash(.label("获取列表失败"), delay: 2)
            }
        }
    }
    
    func getLikeProfileList(at: Position) {
        if likeSenderUserUuid == nil {
            return
        }
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        
        let engine = NetworkEngine()
//        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getLikeProfile(pageNum: String(pageNum), pageSize: String(PageSize)) {  (likeResult) in
            if at == .top {
                self.tableView.endRefreshing(at: .top)
            }else{
                self.tableView.endRefreshing(at: .bottom)
            }
            if likeResult?.status == ResponseError.SUCCESS.0 {
                if let list = likeResult?.data?.list{
                    self.tableView.bottomPullToRefresh?.refreshView.isHidden = (list.count < PageSize)
                    if at == .top {
                        self.dataSource.removeAll()
                    }
                    self.dataSource.append(contentsOf: list)
                    self.tableView.reloadData()
                }
            }else{
                HUD.flash(.label("获取列表失败"), delay: 2)
            }
        }
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 75
        view.addSubview(tableView)
        tableView.register(LikeUsersCell.self, forCellReuseIdentifier: "LikeUsersCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LikeUsersCell = tableView.dequeueReusableCell(withIdentifier: "LikeUsersCell", for: indexPath) as! LikeUsersCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj)
        cell.indexPath = indexPath
        cell.setClosurePass { (actionIndexPath) in
            self.performCellAction( indexPatch: actionIndexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pushVC = UserInfoViewController()
        let userObj = dataSource[indexPath.row]

        pushVC.mUserUuid = userObj.likeSenderUserUuid
        let userUuid = Global.shared.globalProfile?.userUuid
        pushVC.likeSenderUserUuid = userUuid
        pushVC.isMyselfFlag = false
        self.navigationController?.pushViewController(pushVC, animated: true)

    }
    
    
    func performCellAction( indexPatch: IndexPath) {
        SGLog(message: indexPatch.row)
        let pushVC = BrowseAdvertViewController()
//        pushVC.configWithObject(photoObj: user)
        
        self.navigationController?.pushViewController(pushVC, animated: true)
        
    }
    
}

private extension LikeUsersViewController {
    
    func setupPullToRefresh() {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            self?.getLikeUserList(at: .top)
            
        }
        
        tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            self?.getLikeUserList(at: .bottom)
        }
    }
}
