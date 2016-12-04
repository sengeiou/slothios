//
//  ChatExtension.swift
//  SlothChat
//
//  Created by fly on 2016/11/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension BaseViewController{
    func postPrivateChat(nameA: String?,nameB: String?,userUuidA: String?,userUuidB:String?) {
        SGLog(message: "")
        guard let _ = nameA,
            let nameB = nameB,
            let userUuidA = userUuidA,
            let userUuidB = userUuidB,
            let canTalk = Global.shared.globalLogin?.canTalk else {
                SGLog(message: "数据不全")
                return
        }
        if !canTalk {
            self.showNotificationError(message: "请设置第一张个人资料是能识别的真人照片~")
            return
        }
        let engine = NetworkEngine()
        self.showNotificationProgress()
        
        engine.postPrivateChat(name: nameB, userUuidA: userUuidA, userUuidB: userUuidB){ (response) in
            self.hiddenNotificationProgress(animated: false)
            if response?.status == ResponseError.SUCCESS.0{
                self.pushChatViewController(targetId: response?.data?.uuid,userUuid: userUuidB, title: response?.data?.name)
            }else{
                self.showNotificationError(message: response?.msg)
            }
        }
    }
    
    func pushChatViewController(targetId: String?,userUuid: String?,title: String?) {
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: targetId) else {
            return
        }
        chat.title = title
        chat.privateUserUuid = userUuid
        self.navigationController?.pushViewController(chat, animated: true)
    }
}
