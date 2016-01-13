//
//  RSSViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTableViewController.h"

@interface RSSViewController : UIViewController
@property (nonatomic,strong) NSString *value;

- (IBAction)btnNewsTab:(id)sender;
- (IBAction)btnSportsTab:(id)sender;
- (IBAction)btnOrbitsTab:(id)sender;
- (IBAction)btnBirthdaysTab:(id)sender;
- (IBAction)btnStoryTab:(id)sender;
- (IBAction)btnContactTab:(id)sender;
@end
