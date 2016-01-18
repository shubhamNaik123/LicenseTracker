//
//  SubmitStoryViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface SubmitStoryViewController : UIViewController
<MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnHideCancel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *txtStoryTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtViewBody;
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserEmail;
- (IBAction)btnPhotoAttchment:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSendMail:(id)sender;
@end
