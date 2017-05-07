//
//  SCConversationViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import IQKeyboardManager

class SCConversationViewController: RCConversationViewController {
    var officialGroupUuid: String?
    var officialGroup: ChatOfficialGroupVo?
    var officialHeaderView: OfficialGroupHeaderView?
    var privateUserUuid: String?

    let fakeRecordButton = UIButton(type: .custom)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.navigationController != nil &&
            (self.navigationController?.viewControllers.count)! > 1 {
            self.setNavtionBack(imageStr: "go-back")
        } 
        configNormalInputBarControl()
        configNavgitaionItem()

        if self.conversationType == RCConversationType.ConversationType_PRIVATE {
            addPluginBoardView()
        }else if self.conversationType == RCConversationType.ConversationType_GROUP{
            if self.targetId.hasPrefix("officialGroup") {
                //官方群只能语音聊天
                //configGroupInputBarControl()
                sentupTipMessageView(group: officialGroup)
            }else{
                configGroupNotice()
            }
        }
        checkOverdueMessage()
        
        self.register(SGVoiceMessageCell.self, forMessageClass: RCVoiceMessage.self)
        
        
    }
    
    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        if tag == 201 {
            SGLog(message: "发起群聊")
            presentSelectFriendsVC()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
        if !cell.isMember(of: SGVoiceMessageCell.self) {
            return cell
        }
        
        let voiceCell = cell as! SGVoiceMessageCell
        
        //如果是自己发的，或者是已经听过的语音隐藏图标显示
        if voiceCell.messageDirection == .MessageDirection_SEND ||
            voiceCell.model.receivedStatus == .ReceivedStatus_LISTENED {
            voiceCell.clockImgView.isHidden = true
        }else{
            voiceCell.clockImgView.isHidden = false
        }
        return cell
    }
    
    
    override func didTapCellPortrait(_ userId: String!) {

        let pushVC = UserInfoViewController()
        pushVC.mUserUuid = userId
        let userUuid = Global.shared.globalProfile?.userUuid
        pushVC.likeSenderUserUuid = userUuid
        navigationController?.pushViewController(pushVC, animated: true)
    }
}


