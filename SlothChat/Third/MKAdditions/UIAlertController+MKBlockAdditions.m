//
//  UIActionSheet+MKBlockAdditions.m
//  UIKitCategoryAdditions
//
//  Created by Mugunth on 21/03/11.
//  Copyright 2011 Steinlogic All rights reserved.
//

#import "UIAlertController+MKBlockAdditions.h"
#import "UIImage+ReSize.h"

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;
static PhotoPickedBlock _photoPickedBlock;
static UIViewController *_presentVC;
static BOOL isAllowsEditing = YES;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation UIAlertController (MKBlockAdditions)


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
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerController:UIImagePickerControllerSourceTypeCamera];
        }];
        [alertController addAction:cameraButton];
    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction *libraryButton = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        [alertController addAction:libraryButton];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:cancelAction];
    
    [presentVC presentViewController:alertController animated:YES completion:nil];
}


+ (void)photoPickerWithTitle:(NSString*)title
                   showInView:(UIView*)view
                    presentVC:(UIViewController*)presentVC
                onPhotoPicked:(PhotoPickedBlock)photoPicked                   
                     onCancel:(CancelBlock)cancelled
{
    [self photoPickerWithTitle:title showInView:view presentVC:presentVC onPhotoPicked:photoPicked onCancel:cancelled allowsEditing:NO];
    
}


+ (void)presentImagePickerController:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    
    picker.delegate = [self class];
    
#pragma clang diagnostic pop
    picker.allowsEditing = isAllowsEditing;
    
    picker.sourceType = sourceType;
    
    [_presentVC presentViewController:picker animated:YES completion:^{
        
    }];
}

+ (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{

	[picker dismissViewControllerAnimated:YES completion:^{
        UIImage *editedImage = (UIImage*)[info valueForKey:UIImagePickerControllerEditedImage];
        if(!editedImage){
            editedImage = (UIImage*)[info valueForKey:UIImagePickerControllerOriginalImage];
            CGSize newSize = [UIScreen mainScreen].bounds.size;
            newSize.width *= [UIScreen mainScreen].scale;
            newSize.height *= [UIScreen mainScreen].scale;

            editedImage = [editedImage resizedImage:newSize interpolationQuality:kCGInterpolationDefault];
        }
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
