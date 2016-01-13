//
//  EditViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 09/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//
@import UIKit;
#import "DBManager.h"
#import "ViewAllTableViewController.h"

@interface EditViewController : UIViewController

@property (nonatomic,strong) DBManager *model;
@property (nonatomic,strong) NSString *licenseName;
@property (nonatomic,strong) NSString *expiryDate;

@property (weak, nonatomic) IBOutlet UITextField *txlEditName;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickEditDate;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayDate;
@property(nonatomic,assign) int localNotificationID;
- (IBAction)pickerEdit:(id)sender;
- (IBAction)btnCancel:(id)sender;
- (IBAction)btnSave:(id)sender;

@end
