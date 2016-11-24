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
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = BiddingStatusView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 420), status: .bidding)
    
    var isMyself = true
    var isFollow = false
    var mainImgUrl: String?
    var photoObj: UserGalleryPhoto?
    
    var userUuid: String?
    var galleryUuid: String?
    var adsBidOrder: AdsBidOrder?

    override func viewDidLoad() {
        super.viewDidLoad() 
        
        sentupView()
        setNavtionConfirm(titleStr: "发送")
        getAdsBidOrder()
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
        if let rankVos = self.adsBidOrder?.data?.bidAdsRankVos {
            return rankVos.count
        }
        return 0
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
        if adsBidOrder?.data?.bidsEnd == false {
            let timeLabel = UILabel()
            timeLabel.font = UIFont.systemFont(ofSize: 12)
            headerView.addSubview(timeLabel)
            
            timeLabel.snp.makeConstraints { (make) in
                make.right.equalTo(-8)
                make.centerY.equalTo(headerView.snp.centerY)
            }
            
            let string1 = "剩余"
            var string2 = "  "
            if let leftTime = adsBidOrder?.data?.leftDaysHours {
                string2 = leftTime
            }
            
            let attributedText = NSMutableAttributedString.init(string: string1 + string2)
            
            let range = NSRange.init(location: string1.characters.count, length: string2.characters.count)
            attributedText.addAttribute(NSForegroundColorAttributeName, value: SGColor.SGMainColor(), range: range)
            timeLabel.attributedText = attributedText
        }
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BiddingListCell = tableView.dequeueReusableCell(withIdentifier: "BiddingListCell", for: indexPath) as! BiddingListCell
        if let rankVos = self.adsBidOrder?.data?.bidAdsRankVos {
            let rankVo = rankVos[indexPath.row]
            cell.configCellWithObj(rankVo: rankVo,indexPatch: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configWithObject(imageUrl: String?) {
        if let imgUrl = imageUrl {
            self.mainImgUrl = imgUrl
            headerView.configWithObject(imgUrl: imgUrl)
        }
    }
    
    func configWithObject(image: UIImage?) {
//        headerView.configWithObject(image: image!)
    }
    
    //MARK:- Action
    
    override func confirmClick() {
        postAdsBidOrder()
    }
    
    func followClick() {
        likeGallery()
    }
    
    func deleteClick() {
        
        if userUuid == nil || galleryUuid == nil {
            SGLog(message: "数据为空")
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.deletePhotoFromGallery(photoUuid: galleryUuid!) { (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("添加照片成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func likeGallery() {
        if userUuid == nil || galleryUuid == nil {
            SGLog(message: "数据为空")
            return
        }
        
        self.isFollow = !self.isFollow
        self.configNavigationRightItem()
        
        let engine = NetworkEngine()

        engine.postLikeGalleryList(likeSenderUserUuid: userUuid, galleryUuid: galleryUuid) { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
//                self.photoObj?.currentVisitorLiked = true
                
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func getAdsBidOrder() {
        if galleryUuid == nil {
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))

        engine.getAdsBidOrder(bidGalleryUuid: galleryUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.adsBidOrder = response
                
                if let imgUrl = response?.data?.bigPicUrl{
                    self.configWithObject(imageUrl: imgUrl)
                }
                self.headerView.refreshView(rankData: (response?.data)!)
                self.tableView.reloadData()
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func postAdsBidOrder() {
        if galleryUuid == nil {
            SGLog(message: "数据为空")
            return
        }
        guard let oriPrice = adsBidOrder?.data?.myBidAmount else {
            SGLog(message: "原始价格异常")
            return
        }
        let price = headerView.addPrice - oriPrice

        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.postAdsBidOrder(bidGalleryUuid: galleryUuid!, amount: price){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                NotificationCenter.default.post(name: SGGlobalKey.DiscoveryDataDidChange, object: nil)
                HUD.flash(.label("竞价成功"), delay: 2, completion: { (result) in
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }else{
                guard let code = response?.status else{
                    return
                }
                if Int(code) == 301{
                    self.needRecharge(data: response?.data)
                }else{
                    HUD.flash(.label(response?.msg), delay: 2)
                }
            }
        }
    }
    
    func needRecharge(data: BidAdResponseData?) {
        guard let totalPrice = data?.accountsBanlace,
              let needPrice = data?.needPayAmount  else{
                SGLog(message: "数据为空")
                return
        }
        let title = "当前账户余额不足，为￥" + String(totalPrice) + "，需要再充值￥" + String(needPrice) + "，可以吗？"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
            self.purchaseForProduct(price: String(needPrice), productID: "com.ssloth.animal.recharge")
        })
        okAction.setValue(SGColor.SGMainColor(), forKey: "_titleTextColor")
        cancelAction.setValue(UIColor.black, forKey: "_titleTextColor")
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
