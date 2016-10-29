//
//  ImageScrollViewController.swift
//  SlothChat
//
//  Created by Fly on 16/10/29.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import UIKit

class ImageScrollViewController: BaseViewController {
    private let imageScroller = ImageScrollView(frame: CGRect.init(x: 0, y: 55, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 55))
    
    private let toolBar = UIView()
    private let deleteButton = UIButton(type: .custom)
    private let likeButton = UIButton(type: .custom)
    
    var isFollow = false

    override func viewDidLoad() {
        super.viewDidLoad()
        sentupToolBar()
        sentupView()
    }
    
    func sentupToolBar() {
        
        view.addSubview(toolBar)
        toolBar.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(0)
            make.height.equalTo(55)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = SGColor.SGLineColor()
        toolBar.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        
        
        let closeButton = UIButton(type: .custom)
        toolBar.addSubview(closeButton)
        closeButton.snp.makeConstraints{ (make) in
            make.left.equalTo(10)
            make.size.equalTo(CGSize.init(width: 42, height: 42))
            make.centerY.equalTo(toolBar.snp.centerY)
        }
        
        closeButton.setImage(UIImage.init(named: "go-back"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonClick), for: .touchUpInside)
        
        
        toolBar.addSubview(deleteButton)
        deleteButton.snp.makeConstraints{ (make) in
            make.right.equalTo(-8)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
            make.centerY.equalTo(toolBar.snp.centerY)
        }
        
        deleteButton.setImage(UIImage.init(named: "trash-can"), for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        
        
        toolBar.addSubview(likeButton)
        likeButton.snp.makeConstraints{ (make) in
            make.right.equalTo(deleteButton.snp.left).offset(-26)
            make.size.equalTo(CGSize.init(width: 32, height: 32))
            make.centerY.equalTo(toolBar.snp.centerY)
        }
        //heart-solid
        likeButton.setImage(UIImage.init(named: "heart-hollow"), for: .normal)
        likeButton.addTarget(self, action: #selector(likeButtonClick), for: .touchUpInside)
    }
    
    func isShowDeleteButton(isShow: Bool) {
        if !isShow {
            deleteButton.isHidden = !isShow
            likeButton.snp.updateConstraints({ (make) in
                make.right.equalTo(-8)
            })
        }
    }
    
    func sentupView() {
        view.addSubview(imageScroller)
        imageScroller.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.top.equalTo(55)
        }
    }
    
    func disPlay(imageUrl: String) {
//        imageScroller.display(image: UIImage.init(named: "icon")!)

        imageScroller.display(imageUrl: imageUrl)
    }
    
    //MARK: - Action
    
    func closeButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func deleteButtonClick() {
        
    }
    
    func likeButtonClick() {
        isFollow = !isFollow
        refreshLikeButton()
    }
    
    fileprivate func refreshLikeButton() {
        let followImg = isFollow ? "heart-solid" : "heart-hollow"
        likeButton.setImage(UIImage.init(named: followImg), for: .normal)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
