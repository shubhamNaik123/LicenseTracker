//
//  AddNewEntryController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "ViewController.h"
#import "HelpViewController.h"
@interface AddNewEntryController : UIViewController
@property (nonatomic, strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UILabel *lblDisplayDate;
@property (weak, nonatomic) IBOutlet UITextField *licenseName;
@property (weak, nonatomic) IBOutlet UILabel *licenseDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
- (IBAction)pickerAction:(id)sender;
- (IBAction)saveDetails:(UIButton *)sender;
- (IBAction)openHelp:(id)sender;

/*- (IBAction)goToHome:(id)sender;
- (IBAction)viewAll:(id)sender;
- (IBAction)showAll:(id)sender;
- (IBAction)btnLog:(id)sender;*/

@end
