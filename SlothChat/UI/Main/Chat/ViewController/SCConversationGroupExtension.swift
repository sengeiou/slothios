//
//  SCConversationGroupExtend.swift
//  SlothChat
//
//  Created by fly on 2016/11/13.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

extension SCConversationViewController{

    
    func addPluginBoardView() {
        self.chatSessionInputBarControl.pluginBoardView.insertItem(with: UIImage(named: "icon"), title: "和TA建群", tag: 201)
    }
    
    func configGroupInputBarControl() {
        chatSessionInputBarControl.switchButton.isEnabled = false
        chatSessionInputBarControl.emojiButton.isEnabled = false
        chatSessionInputBarControl.additionalButton.setImage(UIImage(named: "icon"), for: .normal)
        chatSessionInputBarControl.setDefaultInputType(RCChatSessionInputBarInputType.voice)
    }
}
