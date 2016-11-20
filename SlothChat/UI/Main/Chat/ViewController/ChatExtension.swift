//
//  ChatExtension.swift
//  SlothChat
//
//  Created by fly on 2016/11/20.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation
import PKHUD

extension UIViewController{
    func postPrivateChat(nameA: String?,nameB: String?,userUuidA: String?,userUuidB:String?) {
        SGLog(message: "")
        guard let nameA = nameA,
            let nameB = nameB,
            let userUuidA = userUuidA,
            let userUuidB = userUuidB,
            let canTalk = Global.shared.globalLogin?.canTalk else {
                SGLog(message: "数据不全")
                return
        }
        if !canTalk {
            HUD.flash(.label("请设置第一张个人资料是能识别的真人照片~"), delay: 2)
            //return
        }
        let engine = NetworkEngine()
        HUD.show(.labeledProgress(title: nil, subtitle: nil))
        
        engine.postPrivateChat(name: nameA + "," + nameB, userUuidA: userUuidA, userUuidB: userUuidB){ (response) in
            HUD.hide()
            if response?.status == ResponseError.SUCCESS.0{
                self.pushChatViewController(targetId: response?.data?.uuid, title: response?.data?.name)
            }else{
                HUD.flash(.label(response?.msg), delay: 2)
            }
        }
    }
    
    func pushChatViewController(targetId: String?,title: String?) {
        guard let chat = SCConversationViewController(conversationType: RCConversationType.ConversationType_PRIVATE, targetId: targetId) else {
            return
        }
        chat.title = title
        self.navigationController?.pushViewController(chat, animated: true)
    }
}
