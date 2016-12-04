//
//  CountryCodeViewController.swift
//  SlothChat
//
//  Created by fly on 16/10/14.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

typealias SelectCodeClosureType = (_ country: List) -> Void

class CountryCodeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    let refreshControl = UIRefreshControl.init()
    let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
    var countryList = [Array<List>]()
    var initialList = [String]()
    
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
        self.configTableView()
        self.getCountryCodeList()
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
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    func refreshAction() {
        refreshControl.beginRefreshing()
        
        self.refreshControl.endRefreshing()
    }
    
    //Mark:- Network
    
    func getCountryCodeList() {
        let engine = NetworkEngine()
        self.showNotificationProgress()
        engine.getPublicCountry(withName: "") { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0 {
                if let list = response?.data?.list{
                    response?.caheForCountryCode()
                    let result = self.splitCountryList(countryList: list)
                    self.countryList.removeAll()
                    self.countryList = result.countryList
                    
                    self.initialList.removeAll()
                    self.initialList = result.initialList
                    self.tableView.reloadData()
                }
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func splitCountryList(countryList: [List]) -> (countryList: [Array<List>],initialList: [String]) {
        let sorteList = countryList.sorted { (list1, list2) -> Bool in
            return (list1.display!.compare(list2.display!) == ComparisonResult.orderedAscending)
        }
        
        var tmpInitial = ""
        var resultList = [Array<List>]()
        var initialList = [String]()
        var subList = [List]()

        for listObj in sorteList{
            
            let index: String.Index = listObj.display!.index(listObj.display!.startIndex, offsetBy: 1)

            let initial = listObj.display?.substring(to: index)
            
            if initial == tmpInitial{
                subList.append(listObj)
            }else{
                initialList.append(initial!)
                tmpInitial = initial!
                
                if subList.count > 0{
                    resultList.append(subList)
                }
                subList = [List]()
                subList.append(listObj)
            }
        }
        if subList.count > 0{
            resultList.append(subList)
        }
        return (resultList,initialList)
    }
    
    // MARK: - UITableViewDelegate,UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return countryList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rowList = countryList[section]
        return rowList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CountryCodeCell = tableView.dequeueReusableCell(withIdentifier: "CountryCodeCell", for: indexPath) as! CountryCodeCell
        let rowList = countryList[indexPath.section]
        let obj = rowList[indexPath.row]
        cell.textLabel?.text = obj.display!
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init()
        let label = UILabel.init()
        let initialStr = initialList[section]
        label.text = initialStr
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
        let rowList = countryList[indexPath.section]
        let obj = rowList[indexPath.row]
        
        if let sp = self.selectPassValue {
            if obj.telPrefix != nil{
                sp(obj)
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return initialList;
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        tableView.scrollToRow(at: NSIndexPath.init(row: 0, section: index) as IndexPath, at: .top, animated: true)
        return index
    }
}

