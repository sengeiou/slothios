//
//  HotestViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/22.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class HotestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = DiscoveryUserObj.getDiscoveryUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
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
    
    //MARK:- NetWork
    func getOrderGallery() {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let userUuid = Global.shared.globalProfile?.userUuid
        engine.getOrderGallery(likeSenderUserUuid: userUuid, displayOrder: .hottest, pageNum: "1", pageSize: "20") { (displayOrder) in
//            if displayOrder?.status == ResponseError.SUCCESS.0 {
//                
//            }else{
//                HUD.flash(.label("获取照片列表失败"), delay: 2)
//            }
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
        
        let pushVC = BrowseAdvertViewController()
        let user = UserObj.defaultUserObj()
        pushVC.configWithObject(user: user)
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func performCellAction(actionType: DiscoveryActionType, indexPath: IndexPath) {
        SGLog(message: actionType)
        SGLog(message: indexPath.row)

        switch actionType {
        case .likeType:
            
            break
        case .mainImgType:
            let userObj = dataSource[indexPath.row]
            let browser = ImageScrollViewController()
            browser.disPlay(imageUrl: userObj.mainImgUrl)
            self.present(browser, animated: true, completion: nil)
            
            break
        case .likeUsersType:
            let pushVC = LikeUsersViewController()
            navigationController?.pushViewController(pushVC, animated: true)
            break
        }
    }
    
}
