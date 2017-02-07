//
//  SGSharePopView.swift
//  SlothChat
//
//  Created by Fly on 16/12/3.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import MonkeyKing

struct Configs {
    
    struct Weibo {
        static let appKey = "1691968029";
        static let appSecert = "ff5b34a6a684d4ca4d86a1eedc12c428";
        static let redirectUri = "http://api.ssloth.com/api/oauth/call";
    }
    
    struct Wechat {
        static let appID = "wxcd1578b764c4f37b";
        static let appKey = "2205c89b80bbe3a85e1c9f712362e519";
    }
    
}

class SGSharePopView: UIView {
    
    
    var accessToken: String?
    
    override init(frame: CGRect ){
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        let bgView = UIView()
        addSubview(bgView)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
        bgView.addGestureRecognizer(tap)
        
        self.backgroundColor = SGColor.clear
        bgView.backgroundColor = SGColor.black.withAlphaComponent(0.6)
        
        bgView.snp.makeConstraints{ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
        
        let sinaButton = UIButton(type: .custom)
        let weichatButton = UIButton(type: .custom)
        let timeLineButton = UIButton(type: .custom)
        
        sinaButton.setImage(UIImage(named: "icon_snweibo"), for: .normal)
        weichatButton.setImage(UIImage(named: "icon_wxsession"), for: .normal)
        timeLineButton.setImage(UIImage(named: "icon_wxtimeline"), for: .normal)

        addSubview(sinaButton)
        addSubview(weichatButton)
        addSubview(timeLineButton)
        
        sinaButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-24)
            make.centerX.equalTo(self).offset(-88)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        weichatButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-24)
            make.centerX.equalTo(self)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        timeLineButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-24)
            make.centerX.equalTo(self).offset(88)
            make.size.equalTo(CGSize.init(width: 60, height: 60))
        }
        
        sinaButton.addTarget(self, action: #selector(sinaButtonClick), for: .touchUpInside)
        weichatButton.addTarget(self, action: #selector(weichatButtonClick), for: .touchUpInside)
        timeLineButton.addTarget(self, action: #selector(timeLineButtonClick), for: .touchUpInside)
    }
    
    func dismiss() {
        UIView.animate(withDuration: 0.3, animations:{
            self.isHidden = true
        })
    }
    //MARK:- Action
    
    func sinaButtonClick() {
        
        let weiboAccount = MonkeyKing.Account.weibo(appID: Configs.Weibo.appKey, appKey: Configs.Weibo.appSecert, redirectURL: Configs.Weibo.redirectUri);
        if !weiboAccount.isAppInstalled {
            MonkeyKing.oauth(for: .weibo) { [weak self] (info, response, error) in
                
                if let accessToken = info?["access_token"] as? String {
                    self?.accessToken = accessToken
                    self?.shareToWeibo();
                }
            }
        }
        else {
            self.shareToWeibo();
        }
        
    }
    
    func shareToWeibo() {
        let message = MonkeyKing.Message.weibo(.default(info: (title: "树懒", description: "树懒：https://itunes.apple.com/us/app/sloth/id1175415914", thumbnail: nil, media: .url(URL(string: "https://itunes.apple.com/us/app/sloth/id1175415914")!)),accessToken: self.accessToken));
        MonkeyKing.deliver(message) { success in
            self.handleShareResult(state: success);
        }
    }
    
    func weichatButtonClick() {
        let message = MonkeyKing.Message.weChat(.session(info: (title: "树懒", description: "树懒：https://itunes.apple.com/us/app/sloth/id1175415914", thumbnail: nil, media: .url(URL(string: "https://itunes.apple.com/us/app/sloth/id1175415914")!))));
        MonkeyKing.deliver(message) { success in
            self.handleShareResult(state: success);
        }
    }
    
    func timeLineButtonClick() {
       let message = MonkeyKing.Message.weChat(.timeline(info: (title: "树懒", description: "树懒：https://itunes.apple.com/us/app/sloth/id1175415914", thumbnail: nil, media: .url(URL(string: "https://itunes.apple.com/us/app/sloth/id1175415914")!))));
        MonkeyKing.deliver(message) { success in
            self.handleShareResult(state: success);
        }
    }
    
    
    func handleShareResult(state: Bool) {
        if state {
            showAlertView(message: "分享成功")
            dismiss()
        }
        else {
            showAlertView(message: "分享未成功")
            dismiss()
        }
    }
    
    func showAlertView(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        
        let tmpApp = UIApplication.shared.delegate as! AppDelegate;
        if let rootVC = tmpApp.window?.rootViewController{
            rootVC.present(alertController, animated: true, completion: nil)
        }
    }
    /*
    func getShareParams() -> NSMutableDictionary {
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "树懒：https://itunes.apple.com/us/app/sloth/id1175415914",
                                          images : nil,
                                          url : NSURL(string:"https://itunes.apple.com/us/app/sloth/id1175415914") as URL!,
                                          title : nil,
                                          type : SSDKContentType.auto)
        return shareParames
    }
 */
}
