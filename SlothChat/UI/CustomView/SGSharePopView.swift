//
//  SGSharePopView.swift
//  SlothChat
//
//  Created by Fly on 16/12/3.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SGSharePopView: UIView {
    
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
        let shareParames = getShareParams()
        
        ShareSDK.share(SSDKPlatformType.typeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            self.handleShareResult(state: state, error: error)
        }
    }
    
    func weichatButtonClick() {
        let shareParames = getShareParams()
        
        ShareSDK.share(SSDKPlatformType.subTypeWechatSession, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            self.handleShareResult(state: state, error: error)
        }
    }
    
    func timeLineButtonClick() {
        let shareParames = getShareParams()
        
        ShareSDK.share(SSDKPlatformType.subTypeWechatTimeline, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            self.handleShareResult(state: state, error: error)
        }
    }
    
    func handleShareResult(state: SSDKResponseState,error :Error?) {
        switch state {
        case .success:
            showAlertView(message: "分享成功")
            dismiss()
        case .fail:
            showAlertView(message: "授权失败,错误描述:\(error)")
        case .cancel:
            showAlertView(message: "操作取消")
        default:
            break
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
    
    func getShareParams() -> NSMutableDictionary {
        
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "树懒：https://itunes.apple.com/us/app/sloth/id1175415914",
                                          images : nil,
                                          url : NSURL(string:"https://itunes.apple.com/us/app/sloth/id1175415914") as URL!,
                                          title : nil,
                                          type : SSDKContentType.auto)
        return shareParames
    }

}
