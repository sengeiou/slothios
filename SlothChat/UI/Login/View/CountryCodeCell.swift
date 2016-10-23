//
//  CountryCodeCell.swift
//  swiftProjects
//
//  Created by fly on 6/11/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit
import SnapKit

class CountryCodeCell: UITableViewCell {
    var titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints({ (make) in
            make.left.equalTo(19)
            make.centerY.equalTo(self.contentView.snp.centerY)
        });
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
