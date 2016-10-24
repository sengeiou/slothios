//
//  PublishViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/23.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class PublishViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let dataSource = UserObj.getTestUserList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    let headerView = PublishHeaderView(frame: CGRect.init(x: 0, y: 0, width: 320, height: 468))
    var isJoin = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sentupView()
        setNavtionConfirm(titleStr: "发送")
    }
    
    func sentupView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        view.addSubview(tableView)
        tableView.register(BiddingListCell.self, forCellReuseIdentifier: "BiddingListCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        headerView.setClosurePass {
            self.isJoin = !self.isJoin
            self.tableView.reloadData()
        }
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
        titleLabel.text = "当前竞价排行"
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
        let userObj = dataSource[indexPath.row]
        cell.configCellWithObj(userObj: userObj,indexPatch: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func configWithObject(image: UIImage) {
        headerView.configWithObject(image: image)
    }
    
    //MARK:- Action
    
    override func confirmClick() {
        SGLog(message: headerView.isJoin)

        SGLog(message: headerView.price)
        _ = navigationController?.popViewController(animated: true)
    }
}
