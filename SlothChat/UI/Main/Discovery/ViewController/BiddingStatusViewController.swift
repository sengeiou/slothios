//
//  BiddingStatusViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class BiddingStatusViewController:  BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = UserObj.getTestUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    

    let headerView = BiddingStatusView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 420), status: .bidding)
    
    var bidstatus: BiddingStatus = .bidding
    var isMyself = true
    var isFollow = false
    var mainImgUrl: String?
    var photoObj: UserGalleryPhoto?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentupView()
        configNavigationRightItem()
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 56
        view.addSubview(tableView)
        tableView.register(BiddingListCell.self, forCellReuseIdentifier: "BiddingListCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapMainImgView))
        headerView.mainImgView.isUserInteractionEnabled = true
        headerView.mainImgView.addGestureRecognizer(tap)
        tableView.tableHeaderView = headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "当前竞价排行"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        headerView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        if bidstatus == .bidding {
            let timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 12)
            headerView.addSubview(timeLabel)
            
            timeLabel.snp.makeConstraints { (make) in
                make.right.equalTo(-8)
                make.centerY.equalTo(headerView.snp.centerY)
            }
            
            let string1 = "剩余"
            let string2 = "3天2小时"
            let attributedText = NSMutableAttributedString.init(string: string1 + string2)
            
            let range = NSRange.init(location: string1.characters.count, length: string2.characters.count)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGMainColor(), range: range)
            timeLabel.attributedText = attributedText
        }
        
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BiddingListCell = tableView.dequeueReusableCell(withIdentifier: "BiddingListCell", for: indexPath) as! BiddingListCell
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj,indexPatch: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configWithObject(galleryPhoto: UserGalleryPhoto) {
        self.photoObj = galleryPhoto
        
        if let imgUrl = galleryPhoto.bigPicUrl {
            self.mainImgUrl = imgUrl
            headerView.configWithObject(imgUrl: imgUrl)
        }
       
    }
    
    //MARK:- Action
    
    func followClick() {
        likeGallery()
    }
    
    func deleteClick() {
        if self.photoObj?.uuid == nil {
            SGLog(message: "数据为空")
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let photoUuid = ""
        engine.deletePhotoFromGallery(photoUuid: photoUuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("添加照片成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    func likeGallery() {
        if self.photoObj == nil {
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let uuid = Global.shared.globalProfile?.uuid
        engine.postLikeGalleryList(likeSenderUserUuid: uuid, galleryUuid: photoObj?.uuid) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
//                self.photoObj?.currentVisitorLiked = true
                self.isFollow = !self.isFollow
                self.configNavigationRightItem()
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func configNavigationRightItem() {
        let followImg = isFollow ? "heart-solid" : "heart-hollow"
        
        let followItem = UIBarButtonItem.init(image: UIImage.init(named: followImg), style: .plain, target: self, action: #selector(followClick))
        followItem.tintColor = UIColor.red
        
        if isMyself {
            let deleteItem = UIBarButtonItem.init(image: UIImage.init(named: "trash-can"), style: .plain, target: self, action: #selector(deleteClick))
            deleteItem.tintColor = SGColor.SGTextColor()

            self.navigationItem.rightBarButtonItems = [deleteItem,followItem]
        }else{
            self.navigationItem.rightBarButtonItem = followItem
        }
        
    }
    
    func tapMainImgView() {
        if mainImgUrl == nil {
            return
        }
        let browser = ImageScrollViewController()
        browser.disPlay(imageUrl: mainImgUrl!)
        self.present(browser, animated: true, completion: nil)
    }
}
