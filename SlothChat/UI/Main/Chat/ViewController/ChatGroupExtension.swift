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
        if self.conversationType == .ConversationType_PRIVATE {
            self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "icon"), title: "和TA建群", tag: 201)
        }
    }
    
    func configNavgitaionItem() {
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(itemButtonClick), for: .touchUpInside)
        let barItem = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barItem
    }
    
    func presentSelectFriendsVC() {
        let tmpVC = SelectFriendsViewController()
        tmpVC.dependVC = self
        tmpVC.officialGroupUuid = self.targetId
        let nav = BaseNavigationController(rootViewController: tmpVC)
        present(nav, animated: true, completion: nil)
    }
    
    
    func configGroupInputBarControl() {
        let control = self.chatSessionInputBarControl!
        control.additionalButton.setImage(UIImage(named: "icon"), for: .normal)
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
        let pushVC = ChatGroupInfoViewController()
        pushVC.groupName = self.title
        pushVC.groupUuid = self.groupUuid
        
        self.navigationController?.pushViewController(pushVC, animated: true)
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
//                HUD.flash(.label(response?.msg), delay: 2)
//            }
//        }
    }
}
