//
//  MyPhotosCell.swift
//  Project05MyPhotos
//
//  Created by fly on 6/8/16.
//  Copyright © 2016 fly. All rights reserved.
//

import UIKit

class MyPhotosCell: UICollectionViewCell {
    let imgView = UIImageView.init()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configCell()
    }
    
    func configCell()  {
        self.clipsToBounds = true
        imgView.frame = self.bounds
        self.addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
