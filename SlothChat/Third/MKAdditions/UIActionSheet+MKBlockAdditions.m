//
//  UIActionSheet+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "UIActionSheet+MKBlockAdditions.h"

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;
static PhotoPickedBlock _photoPickedBlock;
static UIViewController *_presentVC;
static BOOL isAllowsEditing = YES;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation UIActionSheet (MKBlockAdditions)

+(void)actionSheetWithTitle:(NSString*)title
                     message:(NSString*)message
                     buttons:(NSArray*)buttonTitles
                  showInView:(UIView*)view
                   onDismiss:(DismissBlock)dismissed                   
                    onCancel:(CancelBlock)cancelled
{    
    [UIActionSheet actionSheetWithTitle:title 
                                message:message 
                 destructiveButtonTitle:nil 
                                buttons:buttonTitles 
                             showInView:view 
                              onDismiss:dismissed 
                               onCancel:cancelled];
}

+ (void)actionSheetWithTitle:(NSString*)title                     
                      message:(NSString*)message          
       destructiveButtonTitle:(NSString*)destructiveButtonTitle
                      buttons:(NSArray*)buttonTitles
                   showInView:(UIView*)view
                    onDismiss:(DismissBlock)dismissed                   
                     onCancel:(CancelBlock)cancelled
{
    _cancelBlock = nil;
    _cancelBlock  = [cancelled copy];
    
    _dismissBlock = nil;
    _dismissBlock  = [dismissed copy];
    
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:[self class]
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:destructiveButtonTitle
                                                    otherButtonTitles:nil];
#pragma clang diagnostic pop

    
    for(NSString* thisButtonTitle in buttonTitles)
        [actionSheet addButtonWithTitle:thisButtonTitle];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"")];
    actionSheet.cancelButtonIndex = [buttonTitles count];
    
    if(destructiveButtonTitle)
        actionSheet.cancelButtonIndex ++;
    
    if([view isKindOfClass:[UIView class]])
        [actionSheet showInView:view];
    
    if([view isKindOfClass:[UITabBar class]])
        [actionSheet showFromTabBar:(UITabBar*)view];
    
    if([view isKindOfClass:[UIBarButtonItem class]])
        [actionSheet showFromBarButtonItem:(UIBarButtonItem*)view animated:YES];
    
}

+ (void)photoPickerWithTitle:(NSString*)title
                   showInView:(UIView*)view
                    presentVC:(UIViewController*)presentVC
                onPhotoPicked:(PhotoPickedBlock)photoPicked
                     onCancel:(CancelBlock)cancelled
                allowsEditing:(BOOL)allowsEditing{
    _cancelBlock = nil;
    _cancelBlock  = [cancelled copy];
    
    _photoPickedBlock = nil;
    _photoPickedBlock  = [photoPicked copy];
    
    _presentVC = nil;
    _presentVC = presentVC;
    isAllowsEditing = allowsEditing;
    int cancelButtonIndex = -1;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title
                                                             delegate:[self class]
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
#pragma clang diagnostic pop
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"拍照", @"")];
        cancelButtonIndex ++;
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"相册", @"")];
        cancelButtonIndex ++;
    }
    
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"取消", @"")];
    cancelButtonIndex ++;
    
    actionSheet.tag = kPhotoActionSheetTag;
    actionSheet.cancelButtonIndex = cancelButtonIndex;
    
    if([view isKindOfClass:[UIView class]])
        [actionSheet showInView:view];
    
    if([view isKindOfClass:[UITabBar class]])
        [actionSheet showFromTabBar:(UITabBar*)view];
    
    if([view isKindOfClass:[UIBarButtonItem class]])
        [actionSheet showFromBarButtonItem:(UIBarButtonItem*)view animated:YES];
}


+ (void)photoPickerWithTitle:(NSString*)title
                   showInView:(UIView*)view
                    presentVC:(UIViewController*)presentVC
                onPhotoPicked:(PhotoPickedBlock)photoPicked                   
                     onCancel:(CancelBlock)cancelled
{
    [self photoPickerWithTitle:title showInView:view presentVC:presentVC onPhotoPicked:photoPicked onCancel:cancelled allowsEditing:NO];
    
}


+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

	[picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = (UIImage*)[info valueForKey:UIImagePickerControllerEditedImage];
        if(!editedImage)
            editedImage = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
        
        _photoPickedBlock(editedImage);
    }];
}


+ (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // Dismiss the image selection and close the program
    [_presentVC dismissViewControllerAnimated:YES completion:^{
        
    }];
    picker = nil;
    _presentVC = nil;
    if (_cancelBlock){
        _cancelBlock();
    }
}

+(void)actionSheet:(UIActionSheet*)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == [actionSheet cancelButtonIndex])
	{
        if (_cancelBlock){
            _cancelBlock();
        }
	}
    else
    {
        if(actionSheet.tag == kPhotoActionSheetTag)
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                buttonIndex ++;
            }
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            {
                buttonIndex ++;
            }
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
            
            picker.delegate = [self class];

#pragma clang diagnostic pop
            picker.allowsEditing = isAllowsEditing;
            
            if(buttonIndex == 1)
            {                
                picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
            else if(buttonIndex == 2)
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;;
            }
            
            [_presentVC presentViewController:picker animated:YES completion:^{
                
            }];
        }
        else
        {
            if (_dismissBlock){
                _dismissBlock(buttonIndex);
            }
        }
    }
}
@end
#pragma clang diagnostic pop
