//
//  MainTableViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebPageViewController.h"
#import "WebParserViewController.h"
@interface MainTableViewController : UITableViewController<NSXMLParserDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic,strong) NSString *btnName;
@property (nonatomic,strong) NSString *licenseName;
@property (nonatomic,strong) NSString *name;
@property (strong, nonatomic) IBOutlet UITableView *tblListAll;




@end
