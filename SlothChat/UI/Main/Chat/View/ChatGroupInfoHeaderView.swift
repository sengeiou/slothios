//
//  ChatGroupInfoHeaderView.swift
//  SlothChat
//
//  Created by Fly on 16/11/15.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit
import PKHUD

class ChatGroupInfoHeaderView: UIView {
    let groupNameView = ChatGroupInfoInputView()
    let nickName = ChatGroupInfoInputView()
    
    var groupName: String?
    var groupUuid: String?

    var myMemberInfo: ChatMemberInfo?

    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(groupNameView)
        addSubview(nickName)
        groupNameView.isEditing = false
        nickName.isEditing = false
        groupNameView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(44)
        }
        nickName.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(groupNameView.snp.bottom)
            make.height.equalTo(44)
            make.bottom.equalTo(0)
        }
    }
    
    func configWithObject(tmpGroupName: String?,isGroupOwner: Bool,memberInfo: ChatMemberInfo?) {
        guard let groupName = tmpGroupName else {
                return
        }
        myMemberInfo = memberInfo
        self.groupName = groupName
        groupNameView.configInputView(titleStr: "群组名", contentStr: groupName)
        if let memberInfo = memberInfo {
            nickName.configInputView(titleStr: "我的群昵称", contentStr: memberInfo.userDisplayName!)
        }
        groupNameView.editButton.addTarget(self, action: #selector(groupNameEditButtonClick), for: .touchUpInside)
        nickName.editButton.addTarget(self, action: #selector(nickNameEditButtonClick), for: .touchUpInside)
        
        if isGroupOwner {
            groupNameView.editButton.isHidden = false
        }else{
            groupNameView.editButton.isHidden = true
        }
    }
    
    func groupNameEditButtonClick() {
        groupNameView.isEditing = !groupNameView.isEditing
        
        let content = groupNameView.getInputContent()
        if groupNameView.isEditing == false &&
            groupNameView.getSumbitValid() &&
            content != self.groupName! {
            modifyGroupName(newName: content!)
        }
    }
    
    func nickNameEditButtonClick() {
        nickName.isEditing = !nickName.isEditing
        
        let content = nickName.getInputContent()
        if nickName.isEditing == false &&
            nickName.getSumbitValid() {
            modifyUserNickName(newName: content!)
        }
    }
    
    func modifyGroupName(newName: String) {
        if newName.characters.count >= 20 {
            UIViewController.showCurrentViewControllerNotificationError(message: "群组长度不能超过20个字符")
            return
        }
        
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let adminUserUuid = Global.shared.globalProfile?.userUuid
        
        engine.putUserGroup(groupDisplayName: newName, userGroupUuid: groupUuid, adminUserUuid: adminUserUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
//                self.showNotificationError(message: "修改群组名成功")
                NotificationCenter.default.post(name: SGChatGroupKey.UserGroupNameDidChange, object: nil, userInfo: ["NewUserGroupName":newName])
            }else{
                UIViewController.showCurrentViewControllerNotificationError(message: response?.msg)
            }
        }
    }
        
    func modifyUserNickName(newName: String) {
        if newName.characters.count >= 20 {
            UIViewController.showCurrentViewControllerNotificationError(message: "用户昵称长度不能超过20个字符")
            return
        }
        if (groupUuid?.hasPrefix("officialGroup"))! {
            modifyOfficialGroupMemberName(newName: newName)
        }else{
            modifyUserGroupMemberName(newName: newName)
        }
    }
    
    func modifyUserGroupMemberName(newName: String) {
        guard let myMemberInfo = myMemberInfo else {
            SGLog(message: "myMemberInfo 为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let memberUuid = myMemberInfo.memberUuid
        
        engine.putUserGroupMember(userGroupUuid: groupUuid, userGroupMemberUuid: memberUuid, userDisplayName: newName){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
//                 self.showNotificationSuccess(message: "修改用户名成功")
            }else{
                UIViewController.showCurrentViewControllerNotificationError(message: response?.msg)
            }
        }
    }
    
    
    func modifyOfficialGroupMemberName(newName: String) {
        guard let myMemberInfo = myMemberInfo else {
            SGLog(message: "myMemberInfo 为空")
            return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let memberUuid = myMemberInfo.memberUuid
        
        engine.putOfficialGroupMemberName(userDisplayName: newName, officialGroupUuid: groupUuid, officialGroupMemberUuid: memberUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                UIViewController.showCurrentViewControllerNotificationError(message: "修改用户名成功")
            }else{
                UIViewController.showCurrentViewControllerNotificationError(message: response?.msg)
            }
        }
    }
}

class ChatGroupInfoInputView: UIView,UITextFieldDelegate {
    let titleLabel = UILabel()
    let textfield = UITextField()
    let line = UIView()
    
    let editButton = UIButton()
    
    var isEditing = false{
        didSet{
            self.allowEditing(allowEdit: isEditing)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        titleLabel.textColor = SGColor.SGTextColor()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.delegate = self
        
        addSubview(titleLabel)
        addSubview(textfield)
        addSubview(line)
        addSubview(editButton)

        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(10)
            make.width.equalTo(80)
        }
        
        textfield.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(100)
            make.right.equalTo(-70)
        }
        
        line.backgroundColor = SGColor.SGLineColor()
        line.snp.makeConstraints { (make) in
            make.height.equalTo(1)
            make.bottom.equalTo(0)
            make.left.right.equalTo(textfield)
        }
        
        editButton.setTitle("编辑", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        editButton.setTitleColor(SGColor.SGMainColor(), for: .normal)
        editButton.snp.makeConstraints { (make) in
            make.top.bottom.right.equalTo(0)
            make.width.equalTo(60)
        }
    }
    
    func editButtonClick() {
        self.isEditing = !self.isEditing
    }
    
    func allowEditing(allowEdit: Bool) {
        textfield.isEnabled = allowEdit
        line.isHidden = !allowEdit
        
        editButton.setTitle((allowEdit ? "完成" : "编辑"), for: .normal)
    }
    
    func configInputView(titleStr: String,contentStr: String) {
        titleLabel.text = titleStr
        textfield.text = contentStr
    }
    
    func configContent(contentStr: String) {
        textfield.text = contentStr
    }
    
    func getInputContent() -> String? {
        return textfield.text
    }
    
    func getSumbitValid() -> Bool {
        let input = getInputContent()
        if (input?.isEmpty)! {
            return false
        }else{
            return true
        }
    }
    //MARK:- UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
