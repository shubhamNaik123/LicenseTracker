//
//  ViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
@interface ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DBManager *model;

@property (weak, nonatomic) IBOutlet UILabel *upcomingHeader;

@property (weak, nonatomic) IBOutlet UITableView *tbleExpiryLicense;
@property(nonatomic,assign) int notificationID;
- (IBAction)btnOpenHelp:(id)sender;


/*- (IBAction)openViewScreen:(id)sender;
- (IBAction)openAddScreen:(id)sender;

- (IBAction)openLog:(id)sender;
*/
@end

