//
//  SCConversationGroupExtend.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation
import PKHUD

struct SGChatGroupKey {    
    public static let UserGroupNameDidChange = Notification.Name(rawValue: "SlothChat.UserGroupNameDidChange")
}

extension SCConversationViewController{
    
    func sentupTipMessageView(group: ChatOfficialGroupVo?) {
        if officialGroup != nil {
            conversationMessageCollectionView.register(OfficialGroupHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "OfficialGroupHeaderView")
            
            conversationMessageCollectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if officialGroup == nil {
            return CGSize.zero
        }
        
//        let height = officialGroup?.topicMsg!.size
        return CGSize(width: 375, height: 44)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if officialGroup == nil {
            return UICollectionReusableView()
        }
        var v = OfficialGroupHeaderView()
        if kind == UICollectionElementKindSectionHeader{
            v = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "OfficialGroupHeaderView", for: indexPath) as! OfficialGroupHeaderView
            v.configViewWithObject(group: self.officialGroup)
            return v
        }
        return v
    }
    
    func checkOverdueMessage() {
        if self.targetId.hasPrefix("userGroup") {
           return
        }
        //RCMessageModel
        var messageIds = [CLong]()
        let overdueTime = Date().timeIntervalSince1970 - 30 * 60
        
        for tmpModel in conversationDataRepository {
            if let model = tmpModel as? RCMessageModel {
                
                if self.targetId.hasPrefix("officialGroup") {
                    if self.targetId.hasPrefix("officialGroup")  &&
                        model.receivedStatus == .ReceivedStatus_UNREAD &&
                        TimeInterval(model.receivedTime / 1000) > overdueTime{
                        messageIds.append(model.messageId)
                    }else if model.objectName == "RC:InfoNtf"{
                        messageIds.append(model.messageId)
                    }
                }
                
                if model.receivedStatus == .ReceivedStatus_READ {
                    messageIds.append(model.messageId)
                }
            }
        }
        SGLog(message: messageIds)
        if messageIds.count > 0 {
            RCIMClient.shared().deleteMessages(messageIds)
            self.conversationMessageCollectionView.reloadData()
        }
    }
    
    func deleteMessage(after: Double, messageIds: [String]) {
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(after * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            RCIMClient.shared().deleteMessages(messageIds)
            self.conversationMessageCollectionView.reloadData()
        })
    }
    
    func addPluginBoardView() {
        if self.conversationType == .ConversationType_PRIVATE {
            self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "actionbar_group_icon"), title: "和TA建群", tag: 201)
        }
    }
    
    func configNavgitaionItem() {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(itemButtonClick), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func presentSelectFriendsVC() {
        let tmpVC = SelectChatFriendsViewController()
        tmpVC.dependVC = self
        tmpVC.officialGroupUuid = self.officialGroupUuid
        let nav = BaseNavigationController(rootViewController: tmpVC)
        present(nav, animated: true, completion: nil)
    }
    
    func configGroupNotice() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.groupNameDidChange(_:)), name: SGChatGroupKey.UserGroupNameDidChange, object: nil)
    }
    
    func groupNameDidChange(_ notice: Notification?) {
        guard let notice = notice,
              let userInfo = notice.userInfo else {
            return
        }
        
        self.title = userInfo["NewUserGroupName"] as! String?
    }
    
    func configNormalInputBarControl() {
        let control = self.chatSessionInputBarControl!
        control.inputTextView.layer.cornerRadius = 16
        control.inputTextView.layer.masksToBounds = true
    }
    
    func configGroupInputBarControl() {
        let control = self.chatSessionInputBarControl!
        control.additionalButton.setImage(UIImage(named: "AddGroup"), for: .normal)
        control.inputTextView.text = ""
        control.recordButton.isHidden = true
        control.inputTextView.isHidden = true
        //        control.inputTextView.isEnabled = false
        control.switchButton.isEnabled = false
        control.emojiButton.isEnabled = false
        control.emojiButton.isHidden = true
        control.additionalButton.removeTarget(nil, action: nil, for: .allEvents)
        control.additionalButton.addTarget(self, action: #selector(presentSelectFriendsVC), for: .touchUpInside)
        control.setDefaultInputType(RCChatSessionInputBarInputType.voice)
        
        control.addSubview(fakeRecordButton)
        fakeRecordButton.layer.borderColor = SGColor.SGLineColor().cgColor
        fakeRecordButton.layer.borderWidth = 0.5
        fakeRecordButton.layer.cornerRadius = 4
        
        fakeRecordButton.setTitleColor(SGColor.black, for: .normal)
        fakeRecordButton.setTitle(NSLocalizedString("n_hold_to_talk_title", comment: ""), for: .normal)
        fakeRecordButton.setTitleColor(SGColor.black, for: .selected)
        fakeRecordButton.setTitle(NSLocalizedString("n_release_to_send_title", comment: ""), for: .selected)
        fakeRecordButton.setTitleColor(SGColor.black, for: .highlighted)
        fakeRecordButton.setTitle(NSLocalizedString("n_release_to_send_title", comment: ""), for: .highlighted)
        let bundlePath = Bundle.main.bundlePath
            + "/RongCloud.bundle"
        if let bundle = Bundle(path: bundlePath) {
            let normalImg = UIImage(named: "press_for_audio", in: bundle, compatibleWith: nil)
            let downImg = UIImage(named: "press_for_audio_down", in: bundle, compatibleWith: nil)
            fakeRecordButton.setBackgroundImage(normalImg, for: .normal)
            fakeRecordButton.setBackgroundImage(downImg, for: .highlighted)
            fakeRecordButton.setBackgroundImage(downImg, for: .selected)
        }
        
        fakeRecordButton.addTarget(self, action: #selector(touchDownRecordButton), for: .touchDown)
        fakeRecordButton.addTarget(self, action: #selector(touchUpInsideRecordButton), for: .touchUpInside)
        fakeRecordButton.addTarget(self, action: #selector(touchUpOutsideRecordButton), for: .touchUpOutside)
        fakeRecordButton.addTarget(self, action: #selector(touchDragOutsideRecordButton), for: .touchDragExit)
        fakeRecordButton.addTarget(self, action: #selector(touchDragInsideRecordButton), for: .touchDragEnter)
        
        var newFrame = control.recordButton.frame
        newFrame.size.width = control.emojiButton.frame.maxX - control.switchButton.frame.maxX - 8
        fakeRecordButton.frame = newFrame
    }
    
    //MARK:- Action
    func itemButtonClick() {
        if self.conversationType == .ConversationType_PRIVATE {
            let pushVC = UserInfoViewController()
            pushVC.mUserUuid = self.privateUserUuid
            pushVC.likeSenderUserUuid = Global.shared.globalProfile?.userUuid
            
            self.navigationController?.pushViewController(pushVC, animated: true)
        }else if self.conversationType == .ConversationType_GROUP{
            let pushVC = ChatGroupInfoViewController()
            pushVC.groupName = self.title
            pushVC.groupUuid = self.targetId
            
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    func touchDownRecordButton() {
        self.chatSessionInputBarControl.recordButton.sendActions(for: .touchDown)
    }
    
    func touchUpInsideRecordButton() {
        self.chatSessionInputBarControl.recordButton.sendActions(for: .touchUpInside)
    }
    
    func touchUpOutsideRecordButton() {
        self.chatSessionInputBarControl.recordButton.sendActions(for: .touchUpOutside)
    }
    
    func touchDragOutsideRecordButton() {
        self.chatSessionInputBarControl.recordButton.sendActions(for: .touchDragExit)
    }
    
    func touchDragInsideRecordButton() {
        self.chatSessionInputBarControl.recordButton.sendActions(for: .touchDragEnter)
    }
    
    func didTouchSwitchButton(switched: Bool) {
        self.chatSessionInputBarControl.recordButton.isHidden = true
        self.fakeRecordButton.isHidden = !switched
    }
    
    //MARK:- NetWork
    func getGroupInfo() {
        
        //        guard let groupUuid = groupUuid else {
        //            SGLog(message: "groupUuid为空")
        //            return
        //        }
        //        let engine = NetworkEngine()
        //        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        //
        //        engine.getUserGroup(userGroupUuid: groupUuid){ (response) in
        //            HUD.hide()
        //            if response?.status == ResponseError.SUCCESS.0 {
        //                if let group = response?.data{
        //                    self.title = group.groupDisplayName
        //                }
        //            }else{
        //                if response?.msg != nil {
//                    CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: response?.msg, duration: 2)
//                }else{
//                    CSNotificationView.show(in: self, tintColor: SGColor.SGNoticeErrorColor(), image: nil, message: "系统异常", duration: 2)
//                }
        //            }
        //        }
    }
}
