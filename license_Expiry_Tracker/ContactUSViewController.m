//
//  ContactUSViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import "ContactUSViewController.h"

@interface ContactUSViewController ()

@end

@implementation ContactUSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnContactUS:(id)sender {
    NSString *emailTitle;
    // Email Content
    NSString *messageBody;
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"shubham@sjinnovation.com"];
    // NSArray *toRecipents = [NSArray arrayWithObject:@"merlynferns@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (IBAction)btnPhoneNum1:(id)sender {
    [self phoneCall:@"417-256-31331"];
   /* UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:417-256-31331"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }*/
}

- (IBAction)btnPhoneNum2:(id)sender {
    [self phoneCall:@"888-485-9390"];
   /* UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:888-485-9390"]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }*/
}

-(void) phoneCall:(NSString *) number {
    
    NSURL *callUrl = [NSURL URLWithString:number];
    
    if([[UIApplication sharedApplication] canOpenURL:callUrl])
    {
        [[UIApplication sharedApplication] openURL:callUrl];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ALERT" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


@end
