//
//  ContactUSViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

@import UIKit;
@import MessageUI;
@interface ContactUSViewController : UIViewController
<MFMailComposeViewControllerDelegate>
- (IBAction)btnContactUS:(id)sender;
- (IBAction)btnPhoneNum1:(id)sender;
- (IBAction)btnPhoneNum2:(id)sender;
@end
