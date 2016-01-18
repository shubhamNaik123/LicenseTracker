//
//  WebParserViewController.h
//  license_Expiry_Tracker
//
//  Created by iMac2 on 14/01/16.
//  Copyright © 2016 SJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebParserViewController : UIViewController

@property (nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
@property (copy,nonatomic) NSString *linkUrl;
@property (strong,nonatomic) NSArray *Links;


@property  NSInteger LinkNumber;
@property (weak, nonatomic) IBOutlet UITextView *txtViewTitle;
@property (weak, nonatomic) IBOutlet UIImageView *webImg;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UILabel *lblFooter;

@end
