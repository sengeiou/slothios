//
//  SCConversationViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SCConversationViewController: RCConversationViewController {
    var officialGroup: ChatOfficialGroupVo?
    var officialHeaderView: OfficialGroupHeaderView?

    let fakeRecordButton = UIButton(type: .custom)

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.navigationController != nil &&
            (self.navigationController?.viewControllers.count)! > 1 {
            self.setNavtionBack(imageStr: "go-back")
        }
        
        if self.conversationType == RCConversationType.ConversationType_PRIVATE {
            addPluginBoardView()
//            configGroupInputBarControl()
        }else if self.conversationType == RCConversationType.ConversationType_GROUP{
            configNavgitaionItem()
//            getGroupInfo()
            if self.targetId.hasPrefix("officialGroup") {
                //官方群只能语音聊天
                configGroupInputBarControl()
                sentupTipMessageView(group: officialGroup)
            }else{
                configGroupNotice()
            }
        }
        checkOverdueMessage()
    }

    override func pluginBoardView(_ pluginBoardView: RCPluginBoardView!, clickedItemWithTag tag: Int) {
        super.pluginBoardView(pluginBoardView, clickedItemWithTag: tag)
        if tag == 201 {
            SGLog(message: "发起群聊")
            presentSelectFriendsVC()
        }
    }
    
    override func willDisplayMessageCell(_ cell: RCMessageBaseCell!, at indexPath: IndexPath!) {
        if !cell.isMember(of: RCTextMessageCell.self) {
            return
        }
        
        let textCell = cell as! RCTextMessageCell
        
        if textCell.messageDirection == .MessageDirection_SEND {
            textCell.textLabel.textColor = SGColor.SGMainColor();
        }
//        UIImage *image=textCell.bubbleBackgroundView.image;
//        textCell.bubbleBackgroundView.image=[textCell.bubbleBackgroundView.image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height * 0.8, image.size.width * 0.8,image.size.height * 0.2, image.size.width * 0.2)];
//        //      更改字体的颜色
//        textCell.textLabel.textColor=[UIColor redColor];
    }
    
    
    override func didTapCellPortrait(_ userId: String!) {
        print("tap portrait \(userId)")
        let pushVC = UserInfoViewController()
        pushVC.mUserUuid = userId
        let userUuid = Global.shared.globalProfile?.userUuid
        pushVC.likeSenderUserUuid = userUuid
        navigationController?.pushViewController(pushVC, animated: true)
    }
}

