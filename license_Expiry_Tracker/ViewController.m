//
//  ViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 02/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    NSMutableArray *LicenseTrackerArray, *uniqueID;
    NSMutableDictionary *LicenseDetails;
    NSMutableString *LicenseName, *LicenseDate;
    NSMutableArray *tableData1,*tableData2;
    int lastofIndexPath;
}

-(DBManager *) model
{
    if(!_model)
    {
        _model = [[DBManager alloc]init];
    }
    return _model;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    [self.model createDatabasse];
    // Do any additional setup after loading the view, typically from a nib.
    self.tbleExpiryLicense.delegate = self;
    self.tbleExpiryLicense.dataSource = self;
   
   
    [self upComingAlarm];
    
    [self.tbleExpiryLicense reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([tableData1 count]==0)
    {
        self.tbleExpiryLicense.hidden =  YES;
        self.upcomingHeader.hidden = YES;
    }
    else{
        self.tbleExpiryLicense.hidden=NO;
        
    }
        return [tableData1 count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text =[tableData1 objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [tableData2 objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"here====%d",[[uniqueID objectAtIndex:indexPath.row]intValue]);
        self.notificationID = [[uniqueID objectAtIndex:indexPath.row]intValue];
        [self displayConfirmation];
    }
  }

-(void) displayAlert: (NSString *) msg
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"License Expiry Tracker"
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) displayConfirmation
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"License Expiry Tracker"
                                                   message:@"Are you sure you want to delete?"
                                                  delegate: self
                                         cancelButtonTitle:@"Cancel"
                                         otherButtonTitles:@"Delete", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 0)
    {
        [self.tbleExpiryLicense reloadData];
    }
    else if(buttonIndex == 1)
    {
        [self CancelExistingNotification];
        [self upComingAlarm];
        [self.tbleExpiryLicense reloadData];
    }
}


-(void) displayUpcomingLicenseExpiry
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: now options:0];
    
    
    NSString *YesterdayformatedDate = [dateFormat stringFromDate:yesterday];
    NSLog(@"YesterdayformatedDate=%@",YesterdayformatedDate);

    NSString *formatedDate = [dateFormat stringFromDate:yesterday];
    NSDate *weekLater = [yesterday dateByAddingTimeInterval:+8*24*60*60];
    NSString *formatedWeekLaterDate = [dateFormat stringFromDate:weekLater];
    
    tableData1 = [[NSMutableArray alloc]init];
    tableData2 = [[NSMutableArray alloc]init];
    uniqueID = [[NSMutableArray alloc]init];
    for (int i =0; i<[LicenseTrackerArray count]; i++) {
        NSString *date = [[LicenseTrackerArray objectAtIndex:i]objectForKey:@"LicenseDate"];
        if ([formatedDate compare:date] == NSOrderedAscending &&
            [formatedWeekLaterDate compare:date] == NSOrderedDescending) {
                        NSLog(@"LicenseName %@",[[LicenseTrackerArray objectAtIndex:i]objectForKey:@"LicenseName"]);
            NSLog(@"LicenseDate %@",[[LicenseTrackerArray objectAtIndex:i]objectForKey:@"LicenseDate"]);
            
            
            [tableData1 addObject:[[LicenseTrackerArray objectAtIndex:i]objectForKey:@"LicenseName"]];
           [tableData2 addObject:[[LicenseTrackerArray objectAtIndex:i]objectForKey:@"LicenseDate"]];
            [uniqueID addObject:[[LicenseTrackerArray objectAtIndex:i]objectForKey:@"NotificationID"]];

        }

    }
    NSLog(@"uniqueID= %@",uniqueID);
}



- (IBAction)btnOpenHelp:(id)sender {
    [self performSegueWithIdentifier:@"Help" sender:self];
}

-(void) upComingAlarm
{
    UIApplication* objApp = [UIApplication sharedApplication];
    NSArray*    oldNotifications = [objApp scheduledLocalNotifications];
    
    LicenseTrackerArray = [[NSMutableArray alloc]init];
    
    LicenseDetails = [[NSMutableDictionary alloc] init];
    LicenseName = [[NSMutableString alloc] init];
    LicenseDate = [[NSMutableString alloc] init];
    for (int i = 0; i< [oldNotifications count]; i++) {
        UILocalNotification *notif = [oldNotifications objectAtIndex:i];
        
        NSDictionary *userInfoCurrent = notif.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NotificationID"]];
        NSString *LicenseNameLocal=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"LicenseName"]];
        NSString *LicenseDateLocal=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"LicenseDate"]];
        [LicenseDetails setObject:uid forKey:@"NotificationID"];
        [LicenseDetails setObject:LicenseNameLocal forKey:@"LicenseName"];
        [LicenseDetails setObject:LicenseDateLocal forKey:@"LicenseDate"];
        [LicenseTrackerArray addObject:[LicenseDetails copy]];
            }
    NSLog(@"LicenseTrackerArray = %@",LicenseTrackerArray);
    [self displayUpcomingLicenseExpiry];
}


- (void)CancelExistingNotification
{
    NSLog(@"Notification id = %d",self.notificationID);
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NotificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%i",self.notificationID]])
        {
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}

@end
