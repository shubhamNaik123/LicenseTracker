//
//  EditViewController.m
//  license_Expiry_Tracker
//
//  Created by iMac2 on 09/11/15.
//  Copyright (c) 2015 SJI. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end
NSString *editedFormatedDate;
@implementation EditViewController

-(DBManager *) model
{
    if (!_model) {
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
    self.txlEditName.text = self.licenseName;
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *setEditDate = [[NSDate alloc]init];
    setEditDate = [dateFormater dateFromString:self.expiryDate];
    [self.pickEditDate setDate:setEditDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pickerEdit:(id)sender {
}

- (IBAction)btnCancel:(id)sender {
   [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender {
    if([self.txlEditName.text isEqual:@""])
    {
        [self displayAlert:@"Please enter License name!"];
    }
    else
    {
        NSDate *now = [NSDate date];
        NSComparisonResult result = [now compare:self.pickEditDate.date];
        
        if(result == 1)
        {
            [self displayAlert:@"Invalid Expiry Date! Please select future date."];
        }
        else{
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd"];
            editedFormatedDate = [dateFormat stringFromDate:self.pickEditDate.date];
            
                [self CancelExistingNotification];
                [self sendNotification];
                [self displayAlert:@"Data updated succesfully."];
                self.txlEditName.text = @"";
                [self.pickEditDate setDate:[NSDate date]];
                [self.navigationController popViewControllerAnimated:YES];
           
       }
    }
 }

- (void)CancelExistingNotification
{
    NSLog(@"Notification id = %d",self.localNotificationID);
    //cancel alarm
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *eventArray = [app scheduledLocalNotifications];
    for (int i=0; i<[eventArray count]; i++)
    {
        UILocalNotification* oneEvent = [eventArray objectAtIndex:i];
        NSDictionary *userInfoCurrent = oneEvent.userInfo;
        NSString *uid=[NSString stringWithFormat:@"%@",[userInfoCurrent valueForKey:@"NotificationID"]];
        if ([uid isEqualToString:[NSString stringWithFormat:@"%i",self.localNotificationID]])
        {
            [app cancelLocalNotification:oneEvent];
            break;
        }
    }
}


-(void) sendNotification
{
    UIApplication* app = [UIApplication sharedApplication];
    // [app cancelAllLocalNotifications];
    UILocalNotification *ourNotification = [[UILocalNotification alloc]init];
    NSDate *fireDate = self.pickEditDate.date;
    NSLog(@"now=%@",fireDate);
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond ) fromDate:[[NSDate alloc] init]];
    
    [components setHour:-[components hour]];
    [components setMinute:-[components minute]];
    [components setSecond:-[components second]];
    [components setHour:-24];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *yesterday = [cal dateByAddingComponents:components toDate: fireDate options:0];
    
    int rand= arc4random()%100;
    
    NSLog(@"Yesterday=%@",yesterday);
    [ourNotification setFireDate:yesterday];
    NSString *alertMSg = @"1 day for ";
    alertMSg = [alertMSg stringByAppendingString:self.txlEditName.text];
    alertMSg = [alertMSg stringByAppendingString:@" to expire!"];
    [ourNotification setAlertBody:alertMSg];
    [ourNotification setAlertAction:@"Go to App"];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:rand],@"NotificationID",self.txlEditName.text,@"LicenseName",editedFormatedDate,@"LicenseDate", nil];
    // NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:NotificationId],@"NotificationID",@"Alarm",@"AlarmName", nil];
    
    ourNotification.userInfo = dict;
    ourNotification.applicationIconBadgeNumber = [app applicationIconBadgeNumber]+1;
    [app scheduleLocalNotification:ourNotification];
    NSLog(@"Done %@",fireDate);
}


-(void) displayAlert: (NSString *) msg
{
    UIAlertView *displayAlert = [[UIAlertView alloc] initWithTitle:@"License Expiray Tracker" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [displayAlert show];
}
@end
