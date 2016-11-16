//
//  SCConversationGroupExtend.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation
import PKHUD

extension SCConversationViewController{
    


    func addPluginBoardView() {
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "icon"), title: "和TA建群", tag: 201)
    }
    
    func configNavgitaionItem() {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(itemButtonClick), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func configGroupInputBarControl() {
        chatSessionInputBarControl.switchButton.isEnabled = false
        chatSessionInputBarControl.emojiButton.isEnabled = false
        chatSessionInputBarControl.additionalButton.setImage(UIImage(named: "icon"), for: .normal)
        chatSessionInputBarControl.setDefaultInputType(RCChatSessionInputBarInputType.voice)
    }
    
    
    //MARK:- Action
    func itemButtonClick() {
        let pushVC = ChatGroupInfoViewController()
        pushVC.groupInfo = self.groupInfo
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    
    //MARK:- NetWork
    func getGroupInfo() {

        guard let groupUuid = groupUuid else {
            SGLog(message: "groupUuid为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.getUserGroup(userGroupUuid: groupUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                self.title = response?.data?.groupDisplayName
                self.groupInfo = response?.data
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}
