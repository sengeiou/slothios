//
//  HotestViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

private let PageSize = 20

class HotestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    var dataSource = [DisplayOrderPhoto]()
    
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var pageNum = 1
    
    deinit {
        tableView.removePullToRefresh(tableView.bottomPullToRefresh!)
        tableView.removePullToRefresh(tableView.topPullToRefresh!)
    }
    
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
        engine.getOrderGallery(likeSenderUserUuid: userUuid, displayType: .hottest, pageNum: String(pageNum), pageSize: String(PageSize)) { (displayOrder) in
            if at == .top {
                self.tableView.endRefreshing(at: .top)
            }else{
                self.tableView.endRefreshing(at: .bottom)
            }
            
            if displayOrder?.status == ResponseError.SUCCESS.0 {
                if let list = displayOrder?.data?.list{
                    self.tableView.bottomPullToRefresh?.refreshView.isHidden = (list.count < PageSize)
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
            pushVC.photoObj = actionPhotoObj
            navigationController?.pushViewController(pushVC, animated: true)
            break
        }
    }
}

private extension HotestViewController {
    
    func setupPullToRefresh() {
        tableView.addPullToRefresh(PullToRefresh()) { [weak self] in
            self?.getOrderGallery(at: .top)
            
        }
        
        tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [weak self] in
            self?.getOrderGallery(at: .bottom)
        }
    }
}
