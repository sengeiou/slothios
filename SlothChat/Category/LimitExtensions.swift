//
//  LimitExtensions.swift
//  SlothChat
//
//  Created by fly on 2016/12/1.
//  Copyright © 2016年 ssloth.com. All rights reserved.
//

import Foundation

import Foundation

//MARK: - UITextField

extension UITextField {
    
    public override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UITextField.self {
            return
        }
        
        dispatch_once(&Static.token) {
            UITextFieldHelper.sharedInstance
        }
    }
    
    private struct AssociatedKeys {
        static var LimitLength = "LimitLength"
    }
    
    var limitLength: Int? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.LimitLength) as? Int
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.LimitLength,
                    newValue as Int?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    func changeCharactersInRange(range: NSRange, replacementString string: String) -> String {
        assert((self.text! as NSString).length >= (range.location + range.length))
        let headPart = (self.text! as NSString).substring(to: range.location)
        let tailPart = (self.text! as NSString).substring(from: range.location + range.length)
        let newString = "\(headPart)\(string)\(tailPart)"
        return newString
    }
}

//MARK: - UITextFieldHelper

private let singleTone = UITextFieldHelper()

class UITextFieldHelper: NSObject {
    
    /// 单例
    class var sharedInstance : UITextFieldHelper {
        return singleTone
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextFieldHelper.textFieldViewDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
    }
    
    func textFieldViewDidChange(notification: NSNotification) {
        if let textField = notification.object as? UITextField {
            if let limit = textField.limitLength {
                if let _ = textField.markedTextRange {
                    //do nothing
                    return
                }
                
                if let text = textField.text {
                    if (text as NSString).length >= limit {
                        textField.text = (text as NSString).substringWithRange(NSMakeRange(0, limit))
                        textField.sendActionsForControlEvents(.EditingChanged)
                    }
                }
            }
        }
    }
}

//MARK: - UITextView

extension UITextView {
    
    public override class func initialize() {
        
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // make sure this isn't a subclass
        if self !== UITextView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            UITextViewHelper.sharedInstance
        }
    }
    
    private struct AssociatedKeys {
        static var LimitLength = "LimitLength"
    }
    
    var limitLength: Int? {
        
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.LimitLength) as? Int
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.LimitLength,
                    newValue as Int?,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    // tvPlaceholder text
    var tvPlaceholder: String? {
        
        get {
            // Get the tvPlaceholder text from the label
            var tvPlaceholderText: String?
            
            if let tvPlaceholderLabel = self.viewWithTag(100) as? UILabel {
                tvPlaceholderText = tvPlaceholderLabel.text
            }
            return tvPlaceholderText
        }
        
        set {
            // Store the tvPlaceholder text in the label
            if let tvPlaceholderLabel = self.viewWithTag(100) as? UILabel {
                tvPlaceholderLabel.text = newValue
                tvPlaceholderLabel.sizeToFit()
                tvPlaceholderLabel.hidden = (self.text.length > 0)
            } else {
                self.addtvPlaceholderLabel(newValue!)
            }
        }
    }
    
    // Add a tvPlaceholder label to the text view
    func addtvPlaceholderLabel(tvPlaceholderText: String) {
        
        // Create the label and set its properties
        let tvPlaceholderLabel = UILabel()
        tvPlaceholderLabel.text = tvPlaceholderText
        tvPlaceholderLabel.sizeToFit()
        tvPlaceholderLabel.frame.origin.x = 5.0
        tvPlaceholderLabel.frame.origin.y = 5.0
        tvPlaceholderLabel.font = self.font
        tvPlaceholderLabel.textColor = UIColor.lightGrayColor()
        tvPlaceholderLabel.tag = 100
        
        // Hide the label if there is text in the text view
        tvPlaceholderLabel.hidden = (self.text.length > 0)
        
        self.addSubview(tvPlaceholderLabel)
    }
}

//MARK: - UITextViewHelper

private let singleTone = UITextViewHelper()

class UITextViewHelper: NSObject {
    
    /// 单例
    class var sharedInstance : UITextViewHelper {
        return singleTone
    }
    
    override init() {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UITextViewDelegate.textViewDidChange(_:)), name: UITextViewTextDidChangeNotification, object: nil)
    }
    
    func textViewDidChange(notification: NSNotification) {
        if let textView = notification.object as? UITextView {
            if let limit = textView.limitLength {
                if let _ = textView.markedTextRange {
                    //do nothing
                    return
                }
                
                if let text = textView.text {
                    if (text as NSString).length >= limit {
                        textView.text = (text as NSString).substringWithRange(NSMakeRange(0, limit))
                    }
                }
            }
            
            if let tvPlaceholderLabel = textView.viewWithTag(100) {
                if !textView.hasText() {
                    // Get the tvPlaceholder label
                    tvPlaceholderLabel.hidden = false
                }
                else {
                    tvPlaceholderLabel.hidden = true
                }
            }
        }
    }
}
