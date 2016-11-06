//
//  PublishViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class PublishViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate {
    let dataSource = UserObj.getTestUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = PublishHeaderView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 468))
    var isJoin = false
    var bidType = BidAdsType.notParticipateAd
    
    var uploadImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentupView()
        setNavtionConfirm(titleStr: "发送")
        setNavtionBack(imageStr: "close")
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
        headerView.setClosurePass {
            self.isJoin = !self.isJoin
            self.tableView.reloadData()
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapMainImgView))
        headerView.mainImgView.isUserInteractionEnabled = true
        headerView.mainImgView.addGestureRecognizer(tap)
        tableView.tableHeaderView = headerView

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.isJoin ? dataSource.count : 0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.isJoin ? 32 : 0)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if !isJoin {
            return nil
        }
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.text = "z排行"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        headerView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(8)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        
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

        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BiddingListCell = tableView.dequeueReusableCell(withIdentifier: "BiddingListCell", for: indexPath) as! BiddingListCell
//        let userObj = dataSource[indexPath.row]
//        cell.configCellWithObj(rankVo: userObj,indexPatch: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configWithObject(image: UIImage) {
        self.uploadImage = image
        headerView.configWithObject(image: image)
    }
    
    func configWithObject(imageUrl: String) {
        headerView.configWithObject(imageUrl: imageUrl)
    }
    
    //MARK: - NetWork
    
    func uploadPhotoTogallery(price: Int) {
        if uploadImage == nil {
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        engine.postPhotoGallery(picFile: uploadImage!,bidAds:bidType,price: price) { (userPhoto) in
            HUD.hide()
            if userPhoto?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("发布成功"), delay: 2, completion: { (result) in
                    self.dismiss(animated: true, completion: nil)
                })
                
            }else{
                HUD.flash(.label(userPhoto?.msg), delay: 2)
            }
        }
    }
    
    //MARK:- Action
    
    override func confirmClick() {
        SGLog(message: headerView.isJoin)
        let price = 0
        if headerView.isJoin {
            bidType = .isParticipateAd
        }else{
            bidType = .notParticipateAd
        }
        SGLog(message: price)
        if  headerView.isJoin && headerView.price > 1{
            bidType = .isParticipateAd
            
            let needPrice = price - 1
            
            let title = "当前账户余额不足，为￥" + String(price) + "，需要再充值￥" + String(needPrice) + "，可以吗？"
            let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
            })
            okAction.setValue(SGColor.SGMainColor(), forKey: "_titleTextColor")
            cancelAction.setValue(UIColor.black, forKey: "_titleTextColor")

            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        uploadPhotoTogallery(price: price)
    }
    
    override func backClick() {
        dismiss(animated: true, completion: nil)
    }
    
    func tapMainImgView() {
        let browser = ImageScrollViewController()
        self.present(browser, animated: true, completion: nil)

        browser.isShowLikeButton(isShow: false)
        browser.isShowDeleteButton(isShow: false)
        browser.disPlay(image: headerView.mainImgView.image!)
        
    }
}
