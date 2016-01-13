//
//  ViewAllTableViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 04/01/16.
//  Copyright © 2016 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"
#import "EditViewController.h"

@interface ViewAllTableViewController : UITableViewController<UISearchResultsUpdating,UISearchBarDelegate>
@property (nonatomic,strong) DBManager *model;
- (IBAction)btnEdit:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEditLabel;
@property(nonatomic,assign) int notificationID;
@end
