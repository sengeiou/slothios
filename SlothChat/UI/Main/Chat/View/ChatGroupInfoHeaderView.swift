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
    let groupName = ChatGroupInfoInputView()
    let nickName = ChatGroupInfoInputView()
    
    var groupInfo: GroupInfoData?
    var myMemberInfo: ChatMemberInfo!

    override init(frame: CGRect) {
        super.init(frame: frame)
        sentupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sentupView() {
        addSubview(groupName)
        addSubview(nickName)
        groupName.isEditing = false
        nickName.isEditing = false
        groupName.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(44)
        }
        nickName.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(groupName.snp.bottom)
            make.height.equalTo(44)
            make.bottom.equalTo(0)
        }
    }
    
    func configWithObject(tmpGroupInfo: GroupInfoData?,isGroupOwner: Bool,memberInfo: ChatMemberInfo?) {
        guard let tmpGroupInfo = tmpGroupInfo else {
                return
        }
        myMemberInfo = memberInfo
        groupInfo = tmpGroupInfo
        groupName.configInputView(titleStr: "群组名", contentStr: tmpGroupInfo.groupDisplayName!)
        if let memberInfo = memberInfo {
            nickName.configInputView(titleStr: "我的群昵称", contentStr: memberInfo.nickname!)
        }
        groupName.editButton.addTarget(self, action: #selector(groupNameEditButtonClick), for: .touchUpInside)
        nickName.editButton.addTarget(self, action: #selector(nickNameEditButtonClick), for: .touchUpInside)
        
        if isGroupOwner {
            groupName.editButton.isHidden = false
        }else{
            groupName.editButton.isHidden = true
        }
    }
    
    func groupNameEditButtonClick() {
        groupName.isEditing = !groupName.isEditing
        
        let content = groupName.getInputContent()
        if groupName.isEditing == false &&
            groupName.getSumbitValid() &&
            content != groupInfo?.groupDisplayName! {
            modifyGroupName(newName: content!)
        }
    }
    
    func nickNameEditButtonClick() {
        nickName.isEditing = !nickName.isEditing
        
        let content = nickName.getInputContent()
        if nickName.isEditing == false &&
            nickName.getSumbitValid() &&
            content != groupInfo?.groupDisplayName! {
            modifyUserNickName(newName: content!)
        }
    }
    
    func modifyGroupName(newName: String) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let adminUserUuid = Global.shared.globalProfile?.userUuid
        
        engine.putUserGroup(groupDisplayName: newName, userGroupUuid: groupInfo?.uuid, adminUserUuid: adminUserUuid){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("修改群组名成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func modifyUserNickName(newName: String) {
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        let memberUuid = myMemberInfo.memberUuid
        
        engine.putUserGroupMember(userGroupUuid: groupInfo?.uuid, userGroupMemberUuid: memberUuid, userDisplayName: newName){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0 {
                HUD.flash(.label("修改用户名成功"), delay: 2)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
}

class ChatGroupInfoInputView: UIView {
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
            make.left.equalTo(titleLabel.snp.right).offset(10)
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
}
