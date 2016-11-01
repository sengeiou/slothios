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
    var photoObj: DisplayOrderPhoto?
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var pageNum = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "喜欢的人"
        sentupView()
        getLikeGalleryList(at: .top)
    }
    
    //MARK:- NetWork
    
    func getLikeGalleryList(at: Position) {
        if photoObj == nil {
            return
        }
        if at == .top {
            pageNum = 1
        }else{
            pageNum += 1
        }
        
        let engine = NetworkEngine()
        let userUuid = Global.shared.globalProfile?.userUuid

        engine.getLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: photoObj!.uuid, pageNum: String(pageNum), pageSize: String(PageSize)) { (profileResult) in

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
        pushVC.mUserUuid = Global.shared.globalProfile?.userUuid
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
            self?.getLikeGalleryList(at: .top)
            
        }
        
        tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            self?.getLikeGalleryList(at: .bottom)
        }
    }
}
