//
//  PullToRefreshCell.swift
//  swiftProjects
//
//  Created by fly on 6/11/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit
import SnapKit

class PullToRefreshCell: UITableViewCell {
    var iconImageView : UIImageView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        iconImageView = UIImageView.init(frame : CGRect.zero)
        
        self.contentView.addSubview(iconImageView!)
        iconImageView!.snp.makeConstraints({ (make) in
            make.edges.equalTo(UIEdgeInsets.zero)
        });
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
