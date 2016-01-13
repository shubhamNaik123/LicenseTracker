//
//  HelpViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 09/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnFbConnect:(id)sender {
    NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/sjinnovation"];
    SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithURL:URL];
    webViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:webViewController animated:YES completion:NULL];

}
@end
