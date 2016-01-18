//
//  LogViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

@import UIKit;
#import "DBManager.h"

@interface LogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) DBManager *model;
@property (weak, nonatomic) IBOutlet UILabel *lblLogDisp;
@property (weak, nonatomic) IBOutlet UITableView *tblLogDetails;

- (IBAction)btnLogDetails:(id)sender;
@end
