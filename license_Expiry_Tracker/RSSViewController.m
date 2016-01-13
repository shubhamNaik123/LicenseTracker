//
//  RSSViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 17/12/15.
//  Copyright © 2015 SJI. All rights reserved.
//

#import "RSSViewController.h"

@interface RSSViewController ()
{
    NSString *name;
}
@end

@implementation RSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNewsTab:(id)sender {
    self.value=@"News";
    
}

- (IBAction)btnSportsTab:(id)sender {
    self.value=@"Sports";
    [self performSegueWithIdentifier:@"List" sender:self];
}

- (IBAction)btnOrbitsTab:(id)sender {
    self.value=@"Orbits";
    [self performSegueWithIdentifier:@"List" sender:self];
}

- (IBAction)btnBirthdaysTab:(id)sender {
    self.value=@"Birthdays";
    [self performSegueWithIdentifier:@"List" sender:self];
}

- (IBAction)btnStoryTab:(id)sender {
}

- (IBAction)btnContactTab:(id)sender {
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    
    MainTableViewController *transferViewController = segue.destinationViewController;
   if ([segue.identifier isEqualToString:@"List"]) {
       transferViewController.btnName = self.value;
    }
   
}
@end
