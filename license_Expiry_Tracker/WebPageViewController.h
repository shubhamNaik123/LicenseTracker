//
//  WebPageViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 18/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebPageViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (copy,nonatomic) NSString *linkUrl;
@property (strong,nonatomic) NSArray *Links;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) NSString *licenseName;
@property  NSInteger LinkNumber;
@end
