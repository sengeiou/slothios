//
//  SCConversationViewController.swift
//  SlothChat
//
//  Created by Fly on 16/11/9.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class SCConversationViewController: RCConversationViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.register(SimpleMessageCell.self, forMessageClass: SimpleMessage.self)
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
//        let pushVC = UserInfoViewController()
//        pushVC.mUserUuid = model.targetId
//        
//        let userUuid = Global.shared.globalProfile?.userUuid
//        pushVC.likeSenderUserUuid = userUuid
//        navigationController?.pushViewController(pushVC, animated: true)
    }
}
