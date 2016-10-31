//
//  UIActionSheet+MKBlockAdditions.h
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKBlockAdditions.h"

@interface UIAlertController (MKBlockAdditions)<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

+ (void)photoPickerWithTitle:(NSString*)title
                   showInView:(UIView*)view
                    presentVC:(UIViewController*)presentView
                onPhotoPicked:(PhotoPickedBlock)photoPicked                   
                     onCancel:(CancelBlock)cancelled;

+ (void)photoPickerWithTitle:(NSString*)title
                   showInView:(UIView*)view
                    presentVC:(UIViewController*)presentVC
                onPhotoPicked:(PhotoPickedBlock)photoPicked
                     onCancel:(CancelBlock)cancelled
                allowsEditing:(BOOL)allowsEditing;

@end
