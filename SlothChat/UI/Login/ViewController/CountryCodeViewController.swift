//
//  CountryCodeViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/14.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

typealias SelectCodeClosureType = (_ code: String) -> Void

class CountryCodeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let refreshControl = UIRefreshControl.init()
    let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    var dataSource = [Array<CountryCodeObj>]()
    
    var selectPassValue:SelectCodeClosureType?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "国家电话区号"
        self.configDataSource()
        self.configTableView()
    }
    
    func configTableView() {
        tableView.rowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.sectionIndexColor = SGColor.SGTextColor()
        tableView.register(CountryCodeCell.self, forCellReuseIdentifier: "CountryCodeCell")
        self.view.addSubview(tableView)
    }
    
    func configDataSource() {
        for _ in 1...6 {
            var rowList =  [CountryCodeObj]()
            for _ in 1...3{
                let obj = CountryCodeObj.countryCode(name: "中国", code: "86")
                rowList.append(obj)
            }
            dataSource.append(rowList)
        }
    }
    
    func refreshAction() {
        refreshControl.beginRefreshing()
        
        self.refreshControl.endRefreshing()
        
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowList = dataSource[section]
        return rowList.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let rowList = dataSource[indexPath.section]
        let obj = rowList[indexPath.row]
        cell.textLabel?.text = obj.name! + obj.code!
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init()
        let label = UILabel.init()
        label.text = String(section)
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = SGColor.SGTextColor()
        header.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.left.equalTo(18)
            make.bottom.equalTo(-10)
        }
        
        let line = UIView.init()
        line.backgroundColor = SGColor.SGLineColor()
        header.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.bottom.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(1)
        }
        
        return header
    }
    
    func setClosurePass(temClosure: @escaping SelectCodeClosureType){
        self.selectPassValue = temClosure
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.section);
        print(indexPath.row);
        let rowList = dataSource[indexPath.section]
        let obj = rowList[indexPath.row]
        
        if let sp = self.selectPassValue {
            if let code = obj.code{
                sp(code)
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return ["A","B","C","D","E","F"];
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        print("sectionForSectionIndexTitle:" + title + "index:" + String(index))
        tableView.scrollToRow(at: NSIndexPath.init(row: 0, section: index) as IndexPath, at: .top, animated: true)
        return index
    }
}

