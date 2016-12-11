//
//  SettingViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/17.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import AwesomeCache

class SettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    let pickerView = ValuePickerView.init()

    let dataSource = SettingObj.getSettingList()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    var itunesCharge = ItunesCharge.ModelFromCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        sentupView()
        configPickerView()
        getSystemConfig()
        if self.itunesCharge == nil {
            getItunesChargeList()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(iAPPurchaseSuccess(_:)), name: SGIAPPurchaseKey.IAPPurchaseSuccess, object: nil)
        #if DEBUG
            setNavtionConfirm(titleStr: "Debug")
        #endif

    }
    
    func iAPPurchaseSuccess(_ notice: Notification?) {
        
        let settingObj = self.dataSource[3]
        if let banlace = Global.shared.globalSysConfig?.banlace {
            settingObj.titleStr = "账户余额：￥" + String(banlace)
        }
        self.tableView.reloadData()
        
    }
    

    func sentupView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.rowHeight = 74
        view.addSubview(tableView)
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let footerView = UIView(frame: CGRect.init(x: 0, y: 0, width: screenWidth, height: 100))
        let exitButton = UIButton(type: .custom)
        exitButton.layer.cornerRadius = 22
        exitButton.setTitle("退出", for: .normal)
        exitButton.backgroundColor = SGColor.SGMainColor()
        exitButton.addTarget(self, action: #selector(exitButtonClick), for: .touchUpInside)
        footerView.addSubview(exitButton)
        exitButton.snp.makeConstraints { (make) in
            make.left.lessThanOrEqualTo(80)
            make.right.greaterThanOrEqualTo(-80)
            make.top.equalTo(40)
            make.height.equalTo(44)
        }
        tableView.tableFooterView = footerView
    }
    
    func configPickerView() {
        pickerView.pickerTitle = "充值金额"
        let completionBlock: (String?) -> Void = {(_ value: String?) in
            SGLog(message: value)
            guard let price = value?.components(separatedBy: "/").first,
                  let index = Int((value?.components(separatedBy: "/").last)!),
                  let productID = self.itunesCharge?.getItunesChargeProductUuid(index: index - 1) else {
                return
            }

            self.purchaseForProduct(price: price, productID: productID)
        }
        pickerView.valueDidSelect = completionBlock
        if self.itunesCharge != nil {
            self.pickerView.dataSource = itunesCharge!.getItunesChargeAmountList()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : SettingCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        let settingObj = dataSource[indexPath.row]
        cell.configCellWithObj(settingObj: settingObj)
        if indexPath.row == 0 || indexPath.row == 4 {
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .default
        }else{
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }
        cell.selectButton.isHidden = !(indexPath.row == 1 || indexPath.row == 2)
        cell.dependVC = self    
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var pushVC : UIViewController?
        if indexPath.row == 0 {
            pushVC = ModifyPasswordViewController()
        }else if indexPath.row == 4{
            pushVC = AboutUsViewController()
        }else if indexPath.row == 3{
            charge()
            return
        }
        
        if let pushVC = pushVC {
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    //Mark:- Action
    
    override func confirmClick() {
        let pushVC = DebugViewController()
        navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func charge() {
        if self.itunesCharge != nil {
            pickerView.show()
        }
    }
    
    func exitButtonClick() {
        
        let alertController = UIAlertController(title: "是否退出树懒", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:nil)
        let okAction = UIAlertAction(title: "退出", style: .default, handler:{ (action) in
            self.logout()
        })
        okAction.setValue(SGColor.SGMainColor(), forKey: "_titleTextColor")
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK:- Network
    
    func getSystemConfig()  {
        let engine = NetworkEngine()
        engine.getSysConfig { (config) in
            if config?.status == ResponseError.SUCCESS.0 {
                Global.shared.globalSysConfig = config?.data
                let settingObj = self.dataSource[3]
                if let banlace = config?.data?.banlace {
                    settingObj.titleStr = "账户余额：￥" + String(banlace)
                }
                self.tableView.reloadData()
            }else{
                SGLog(message: "获取系统配置失败")
            }
        }
    }
    
    func getItunesChargeList()  {
        let engine = NetworkEngine()
        engine.getItunesChargeList { (response) in
            if response?.status == ResponseError.SUCCESS.0 {
                self.itunesCharge = response
                response?.caheForModel()
                self.pickerView.dataSource = response?.getItunesChargeAmountList()
            }else{
                SGLog(message: "获取充值可选的价格列表失败")
            }
        }
    }

    
    func logout() {
        let engine = NetworkEngine()
        self.showNotificationProgress()
        
        engine.postAuthLogout() { (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                Global.shared.logout()
                ItunesCharge.removeFromCache()
                RCIM.shared().disconnect(false)
                NotificationCenter.default.post(name: SGGlobalKey.LoginStatusDidChange, object: nil)
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
}
